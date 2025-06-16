#!/bin/bash
set -o errexit  # Exit immediately if any command fails

# System dependencies for Pillow (Render's environment allows apt-get)
echo "---- Installing system dependencies ----"
apt-get update -qq && \
apt-get install -y --no-install-recommends \
    libjpeg-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libwebp-dev > /dev/null 2>&1 || true

# Python package installation
echo "---- Installing Python packages ----"
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt  # Recommended over individual installs

# Specific package workarounds
echo "---- Installing Pillow with workaround ----"
pip install --pre pillow==9.5.0 --no-build-isolation

# Database setup
echo "---- Running database migrations ----"
python manage.py makemigrations --noinput
python manage.py migrate --noinput

# Static files
echo "---- Collecting static files ----"
python manage.py collectstatic --noinput

# Verification
echo "===== BUILD COMPLETED SUCCESSFULLY ====="
python -c "from PIL import Image; print(f'Pillow version: {Image.__version__}')"