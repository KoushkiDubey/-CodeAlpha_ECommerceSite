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
python manage.py check --database default
python manage.py dbshell <<EOF
\dt
\q
EOF