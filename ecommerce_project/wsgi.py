
import os
from django.core.wsgi import get_wsgi_application
import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'ecommerce_project.settings')

if os.environ.get('RENDER'):
    try:
        application = get_wsgi_application()  

       
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
        application = get_wsgi_application()  
else:
    application = get_wsgi_application()
