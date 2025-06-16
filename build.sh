#!/bin/bash
set -e

# Create static directory if missing
mkdir -p static

# Install dependencies
pip install -r requirements.txt

# Apply database migrations
python manage.py migrate

# Collect static files
python manage.py collectstatic --noinput