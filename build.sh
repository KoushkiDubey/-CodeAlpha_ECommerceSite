#!/bin/bash
set -e

# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Apply database migrations
python manage.py migrate

# Collect static files (will now work with STATIC_ROOT set)
python manage.py collectstatic --noinput