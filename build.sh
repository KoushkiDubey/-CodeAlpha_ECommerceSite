#!/bin/bash
# Exit on errors
set -o errexit

# Force clean Django installation
#!/bin/bash
# Exit on errors
set -o errexit

# Nuclear option - clean environment
rm -rf .venv/
python -m venv .venv
source .venv/bin/activate

# Force clean Django installation
pip install --upgrade pip
pip install --force-reinstall Django==4.2.11

# Core dependencies
pip install gunicorn==20.1.0
pip install psycopg2-binary==2.9.9
pip install whitenoise==6.6.0
pip install dj-database-url==2.1.0
pip install Pillow==9.5.0

# Database setup
python manage.py makemigrations
python manage.py migrate

# Static files
mkdir -p staticfiles
python manage.py collectstatic --noinput

# Verification
echo "===== SUCCESS ====="
python manage.py check --deploy