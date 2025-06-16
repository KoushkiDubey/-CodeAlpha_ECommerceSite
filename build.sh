#!/bin/bash
# Exit on errors
set -o errexit

# Clean reinstalls (critical fix)
pip uninstall -y Django
pip install --force-reinstall Django==4.2.11

# Install other dependencies
pip install gunicorn==20.1.0
pip install psycopg2-binary==2.9.9
pip install whitenoise==6.6.0
pip install dj-database-url==2.1.0
pip install Pillow==9.5.0

# Migration commands
python manage.py makemigrations
python manage.py migrate --noinput

# Static files
mkdir -p staticfiles
python manage.py collectstatic --noinput