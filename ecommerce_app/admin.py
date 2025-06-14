from django.contrib import admin
from .models import Product, Category, Cart, CartItem, Order


admin.site.register(Category)
admin.site.register(Cart)
admin.site.register(CartItem)
admin.site.register(Order)

# Register your models here.
@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ('name', 'price', 'featured', 'get_featured_until')  # Use method if dynamic
    list_editable = ('featured',)  # Must be in list_display and a non-readonly field
    list_filter = ('featured', 'category')

    def get_featured_until(self, obj):
        return obj.featured_until  # Handles cases where field is nullable
    get_featured_until.short_description = 'Featured Until'  # Optional: Column name