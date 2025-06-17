"""
WSGI config for ecommerce_project project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.2/howto/deployment/wsgi/
"""
import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'ecommerce_project.settings')

# Render.com auto-migration fix (safe version)
if os.environ.get('RENDER'):
    try:
        # First initialize Django normally
        application = get_wsgi_application()

        # Then check if our tables exist
        from django.db import connection
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT EXISTS (
                    SELECT FROM information_schema.tables 
                    WHERE table_name = 'ecommerce_app_product'
                )
            """)
            table_exists = cursor.fetchone()[0]

        if not table_exists:
            print("🛠️  Missing database tables - running migrations...")
            from django.core.management import call_command
            call_command('migrate', '--noinput')

    except Exception as e:
        print(f"⚠️  Database check failed: {str(e)}")
        # Initialize without migrations if there's an error
        application = get_wsgi_application()
else:
    application = get_wsgi_application()

