# render_settings.py
from .settings import *  # Import all your local settings

# Production overrides
DEBUG = False
ALLOWED_HOSTS = ['codealpha-ecommercesite-3.onrender.com']  # ← Replace with your future Render URL
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

# Database (Render provides this automatically)
import dj_database_url
DATABASES = {
    'default': dj_database_url.config(default=os.environ.get('DATABASE_URL'))
}