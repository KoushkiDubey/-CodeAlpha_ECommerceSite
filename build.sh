#!/bin/bash
set -e  # Exit on error

# Pillow dependencies
apt-get update && apt-get install -y \
    python3-dev \
    libjpeg-dev \
    zlib1g-dev

pip install -r requirements.txt
python manage.py collectstatic --noinput
python manage.py migrate