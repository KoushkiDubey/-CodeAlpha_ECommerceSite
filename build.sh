#!/bin/bash
set -o errexit

# 1. Install system dependencies for Pillow
apt-get update && \
apt-get install -y --no-install-recommends \
    libjpeg-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libwebp-dev || true

# 2. Install Python packages
pip install --upgrade pip setuptools wheel
pip install --no-cache-dir Pillow==9.5.0 --no-build-isolation
pip install Django==4.2.11 gunicorn==20.1.0 psycopg2-binary==2.9.9

# 3. NUCLEAR OPTION - Reset migrations
find . -path "*/migrations/*.py" -not -name "__init__.py" -delete
find . -path "*/migrations/*.pyc" -delete

# 4. Database setup
python manage.py makemigrations
python manage.py migrate --run-syncdb  # Creates tables without migrations
python manage.py migrate  # Apply any remaining migrations

# 5. Static files
python manage.py collectstatic --noinput

# 6. Verification
echo "===== VERIFICATION ====="
python manage.py showmigrations
python manage.py check --deploy