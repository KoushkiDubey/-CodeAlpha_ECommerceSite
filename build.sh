#!/bin/bash
set -e

# Clean install without dependency conflicts
pip install --upgrade pip
pip install --no-cache-dir -r requirements.txt

# Django setup
python manage.py collectstatic --noinput
python manage.py migrate