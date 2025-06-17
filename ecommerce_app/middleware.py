# ecommerce_app/middleware.py
from django.contrib import messages
from .models import Cart

class ActiveCartMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # Only process authenticated users
        if request.user.is_authenticated:
            # Check if user has an active cart
            active_cart = Cart.objects.filter(
                user=request.user,
                is_active=True
            ).first()

            # If no active cart exists, create one
            if not active_cart:
                Cart.objects.create(user=request.user)
                messages.debug(request, "New active cart created")

        response = self.get_response(request)
        return response