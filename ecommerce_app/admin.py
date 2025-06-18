from django.contrib import admin
from .models import Product, Category, Cart, CartItem, Order


admin.site.register(Category)
admin.site.register(Cart)
admin.site.register(CartItem)
admin.site.register(Order)


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ('name', 'price', 'featured', 'get_featured_until')  
    list_editable = ('featured',) 
    list_filter = ('featured', 'category')

    def get_featured_until(self, obj):
        return obj.featured_until  
    get_featured_until.short_description = 'Featured Until' 
