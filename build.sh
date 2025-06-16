#!/bin/bash
# Exit on errors
set -o errexit

# Install Python dependencies
pip install Django==4.2.11
pip install gunicorn==20.1.0
pip install psycopg2-binary==2.9.9
pip install whitenoise==6.6.0
pip install dj-database-url==2.1.0
pip install Pillow==9.5.0  # ← CORRECTED VERSION

# Create static directory
mkdir -p staticfiles

# Collect static files
python manage.py collectstatic --noinput

# Apply database migrations
python manage.py migrate --noinput