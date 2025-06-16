#!/bin/bash
set -o errexit

# 1. Clean environment
rm -rf .venv/
python -m venv .venv
source .venv/bin/activate

# 2. Install system dependencies for Pillow
apt-get update && \
apt-get install -y --no-install-recommends \
    libjpeg-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libwebp-dev || true

# 3. Install Python packages
pip install --upgrade pip setuptools wheel
pip install Django==4.2.11
pip install gunicorn==20.1.0
pip install psycopg2-binary==2.9.9
pip install whitenoise==6.6.0
pip install dj-database-url==2.1.0
pip install --pre pillow==9.5.0 --no-build-isolation

# 4. NUCLEAR OPTION - Reset migrations completely
find . -path "*/migrations/*.py" -not -name "__init__.py" -delete
find . -path "*/migrations/*.pyc" -delete

# 5. Database setup (force table creation)
python manage.py makemigrations
python manage.py migrate --run-syncdb  # Creates all tables without migrations
python manage.py migrate  # Apply any remaining migrations

# 6. Static files
mkdir -p staticfiles
python manage.py collectstatic --noinput

# 7. Verification
echo "===== VERIFICATION ====="
python manage.py showmigrations
python manage.py check --deploy