#!/bin/bash
set -o errexit

# 1. First install system dependencies for Pillow
apt-get update && \
apt-get install -y --no-install-recommends \
    libjpeg-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libwebp-dev \
    libopenjp2-7-dev \
    libtiff5-dev || true

# 2. Install Python packages in correct order
pip install --upgrade pip setuptools wheel
pip install --no-cache-dir Pillow==9.5.0 --no-build-isolation
pip install Django==4.2.11 gunicorn==20.1.0 psycopg2-binary==2.9.9
pip install whitenoise==6.6.0 dj-database-url==2.1.0

# 3. Database setup
python manage.py migrate --noinput

# 4. Static files
python manage.py collectstatic --noinput

# 5. Verification
echo "===== PILLOW INSTALLED SUCCESSFULLY ====="
python -c "from PIL import Image; print(f'Pillow version: {Image.__version__}')"