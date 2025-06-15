import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'ecommerce_project.settings')
django.setup()

from django.contrib.auth import get_user_model

User = get_user_model()
if not User.objects.filter(username="codealpha").exists():
    User.objects.create_superuser(
        username="codealpha",
        password="CodeAlpha@123",
        email="review@codealpha.com"
    )
    print("✅ Admin user created: codealpha / CodeAlpha@123")
else:
    print("⚠️ User already exists")