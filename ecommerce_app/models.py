from django.db import models
from django.contrib.auth.models import User
from django.core.validators import MinValueValidator
from django.utils import timezone
from decimal import Decimal
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from django.db.models.manager import Manager
    from django.db.models.query import QuerySet


class Category(models.Model):
    name = models.CharField(max_length=100)

    if TYPE_CHECKING:
        objects: Manager['Category']
        product_set: QuerySet['Product']

    def __str__(self):
        return self.name


class Product(models.Model):
    name = models.CharField(max_length=200)
    description = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
    image = models.ImageField(upload_to='products/')
    category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True)
    stock = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    featured = models.BooleanField(default=False)
    featured_until = models.DateField(null=True, blank=True)

    if TYPE_CHECKING:
        objects: Manager['Product']
        cartitem_set: QuerySet['CartItem']

    @property
    def is_currently_featured(self) -> bool:
        if self.featured_until:
            return self.featured and self.featured_until >= timezone.now().date()
        return self.featured

    class Meta:
        ordering = ['-featured']  # Featured products appear first

    def __str__(self):
        return self.name


class Cart(models.Model):
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='carts'
    )
    created_at = models.DateTimeField(auto_now_add=True)
    is_active = models.BooleanField(default=True)

    if TYPE_CHECKING:
        objects: Manager['Cart']
        cartitem_set: QuerySet['CartItem']
        order_set: QuerySet['Order']

    class Meta:
        ordering = ['-created_at']

    @property
    def total_price(self) -> Decimal:
        return sum(item.total_price for item in self.cartitem_set.all())


class CartItem(models.Model):
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(
        default=1,
        validators=[MinValueValidator(1)]
    )

    if TYPE_CHECKING:
        objects: Manager['CartItem']

    @property
    def total_price(self) -> Decimal:
        return self.product.price * self.quantity


class Order(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE)
    shipping_address = models.TextField()
    payment_method = models.CharField(max_length=50)
    created_at = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=20, default='Pending')

    if TYPE_CHECKING:
        objects: Manager['Order']

    @property
    def total_price(self) -> Decimal:
        return self.cart.total_price