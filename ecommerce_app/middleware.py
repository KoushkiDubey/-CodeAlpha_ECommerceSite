
from django.contrib import messages
from .models import Cart

class ActiveCartMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
       
        if request.user.is_authenticated:
           
            active_cart = Cart.objects.filter(
                user=request.user,
                is_active=True
            ).first()

            if not active_cart:
                Cart.objects.create(user=request.user)
                messages.debug(request, "New active cart created")

        response = self.get_response(request)
        return response
