from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import login, authenticate, logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import Product, Cart, CartItem, Order, Category
from .forms import RegistrationForm, LoginForm, CheckoutForm
from django.shortcuts import render, get_object_or_404
from django.core.exceptions import MultipleObjectsReturned
from django.utils import timezone

def category_products(request, category_id):
    category = get_object_or_404(Category, id=category_id)
    products = Product.objects.filter(category=category)
    categories = Category.objects.all()

    return render(request, 'ecommerce_app/category_products.html', {
        'products': products,
        'categories': categories,
        'current_category': category,
        'is_category_view': True
    })
def index(request):
    featured_products = Product.objects.filter(
        featured=True,
        featured_until__gte=timezone.now().date()  # Only currently featured
    )[:8]  # Limit to 8 featured products

    regular_products = Product.objects.exclude(
        id__in=[p.id for p in featured_products]
    )[:12]  # Show 12 regular products

    return render(request, 'ecommerce_app/index.html', {
        'featured_products': featured_products,
        'regular_products': regular_products,
        'categories': Category.objects.all()
    })


def product_detail(request, product_id):
    product = get_object_or_404(Product, pk=product_id)
    return render(request, 'ecommerce_app/product_detail.html', {
        'product': product,
    })


@login_required
def view_cart(request):
    cart = Cart.objects.filter(user=request.user, is_active=True).first()
    if not cart:
        cart = Cart.objects.create(user=request.user)
    return render(request, 'ecommerce_app/cart.html', {'cart': cart})
@login_required
@login_required
def add_to_cart(request, product_id):
    cart = Cart.objects.filter(user=request.user, is_active=True).first()
    if not cart:
        cart = Cart.objects.create(user=request.user)

    product = get_object_or_404(Product, pk=product_id)
    cart_item, created = CartItem.objects.get_or_create(
        cart=cart,
        product=product,
        defaults={'quantity': 1}
    )

    if not created:
        cart_item.quantity += 1
        cart_item.save()

    return redirect('view_cart')

@login_required
def remove_from_cart(request, item_id):
    cart_item = get_object_or_404(CartItem, pk=item_id, cart__user=request.user)
    cart_item.delete()
    return redirect('view_cart')

@login_required
def update_cart_item(request, item_id):
    if request.method == 'POST':
        quantity = int(request.POST.get('quantity', 1))
        cart_item = get_object_or_404(CartItem, pk=item_id, cart__user=request.user)

        if quantity > 0:
            cart_item.quantity = quantity
            cart_item.save()
        else:
            cart_item.delete()

    return redirect('view_cart')

@login_required
def checkout(request):
    cart = get_object_or_404(Cart, user=request.user, is_active=True)

    if request.method == 'POST':
        form = CheckoutForm(request.POST)
        if form.is_valid():
            order = Order.objects.create(
                user=request.user,
                cart=cart,
                shipping_address=form.cleaned_data['shipping_address'],
                payment_method=form.cleaned_data['payment_method'],
                status='Processing'
            )

            # Deactivate the used cart
            cart.is_active = False
            cart.save()

            return render(request, 'ecommerce_app/order_confirmation.html', {
                'order': order,
            })

    form = CheckoutForm()
    return render(request, 'ecommerce_app/checkout.html', {
        'cart': cart,
        'form': form,
    })
def register(request):
    if request.method == 'POST':
        form = RegistrationForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            return redirect('index')
    else:
        form = RegistrationForm()

    return render(request, 'ecommerce_app/register.html', {
        'form': form,
    })

def user_login(request):
    if request.method == 'POST':
        form = LoginForm(request.POST)
        if form.is_valid():
            username = form.cleaned_data['username']
            password = form.cleaned_data['password']
            user = authenticate(request, username=username, password=password)

            if user is not None:
                login(request, user)
                return redirect('index')
            else:
                messages.error(request, 'Invalid username or password.')
    else:
        form = LoginForm()

    return render(request, 'ecommerce_app/login.html', {
        'form': form,
    })

@login_required
def user_logout(request):
    logout(request)
    return redirect('index')

# Create your views here.
