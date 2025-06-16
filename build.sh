#!/bin/bash
# Exit on errors
set -o errexit

# Force clean Django installation
pip uninstall -y Django || true
pip install --force-reinstall Django==4.2.11

# Install dependencies
pip install gunicorn==20.1.0
pip install psycopg2-binary==2.9.9
pip install whitenoise==6.6.0
pip install dj-database-url==2.1.0
pip install Pillow==9.5.0

# Nuclear option - reset migrations
find . -path "*/migrations/*.py" -not -name "__init__.py" -delete
find . -path "*/migrations/*.pyc" -delete

# Database setup
python manage.py makemigrations
python manage.py migrate --fake
python manage.py migrate --run-syncdb
python manage.py migrate

# Static files
mkdir -p staticfiles
python manage.py collectstatic --noinput

# Verify
echo "===== Migration Verification ====="
python manage.py showmigrations