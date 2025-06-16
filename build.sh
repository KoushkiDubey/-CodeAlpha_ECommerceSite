#!/bin/bash
set -o errexit

# Clean environment
rm -rf .venv/
python -m venv .venv
source .venv/bin/activate

# Install system dependencies (without sudo)
apt-get update && apt-get install -y \
    libjpeg-dev \
    zlib1g-dev \
    libfreetype6-dev \
    liblcms2-dev \
    libwebp-dev || true

# Upgrade pip and setuptools first
pip install --upgrade pip setuptools wheel

# Install Pillow with explicit build isolation disabled
pip install Pillow==9.5.0 --no-build-isolation

# Install other dependencies
pip install Django==4.2.11
pip install gunicorn==20.1.0
pip install psycopg2-binary==2.9.9
pip install whitenoise==6.6.0
pip install dj-database-url==2.1.0

# Database setup
python manage.py makemigrations
python manage.py migrate

# Static files
mkdir -p staticfiles
python manage.py collectstatic --noinput