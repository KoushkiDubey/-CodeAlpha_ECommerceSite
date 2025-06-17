#!/bin/bash
set -o errexit

# 1. Install system dependencies for Pillow (without sudo)
apt-get update && \
apt-get install -y --no-install-recommends \
    libjpeg-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libwebp-dev || true

# 2. Install Python packages
pip install --upgrade pip setuptools wheel
pip install Django==4.2.11 gunicorn==20.1.0 psycopg2-binary==2.9.9
pip install pillow==9.5.0 --no-build-isolation  # Critical Pillow installation
pip install whitenoise==6.6.0 dj-database-url==2.1.0

# 3. NUCLEAR DATABASE FIX
# First create tables manually
python manage.py dbshell <<EOF
CREATE TABLE IF NOT EXISTS ecommerce_app_product (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    price DECIMAL(10,2),
    description TEXT,
    featured_until TIMESTAMP WITH TIME ZONE,
    -- Add all other columns from your model
    image VARCHAR(100)  # Example column for Pillow ImageField
);
EOF

# 4. Then create and fake migrations
python manage.py makemigrations
python manage.py migrate --fake-initial

# 5. Static files
python manage.py collectstatic --noinput

# 6. Verification
echo "===== SYSTEM VERIFICATION ====="
python -c "from PIL import Image; print(f'Pillow {Image.__version__} installed')"
python manage.py dbshell <<EOF
\d ecommerce_app_product
EOF