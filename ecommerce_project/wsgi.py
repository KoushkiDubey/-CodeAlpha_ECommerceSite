"""
WSGI config for ecommerce_project project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.2/howto/deployment/wsgi/
"""
import os
from django.core.wsgi import get_wsgi_application
import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'ecommerce_project.settings')

# Render-specific initialization
if os.environ.get('RENDER'):
    try:
        application = get_wsgi_application()  # Initialize Django first

        # Then check database
        from django.db import connection
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT 1 FROM information_schema.tables 
                WHERE table_name = 'ecommerce_app_product'
                LIMIT 1
            """)
            if not cursor.fetchone():
                print("🛠️  Running migrations...")
                from django.core.management import call_command
                call_command('migrate', '--noinput')
    except Exception as e:
        print(f"⚠️  Initialization error: {str(e)}")
        application = get_wsgi_application()  # Fallback
else:
    application = get_wsgi_application()