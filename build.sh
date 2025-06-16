#!/bin/bash
set -o errexit

#!/bin/bash
set -o errexit

# 1. Clean environment and force Django reinstallation
rm -rf .venv/
python -m venv .venv
source .venv/bin/activate

# 2. First install wheel and setuptools
pip install --upgrade pip wheel setuptools

# 3. Install Django FIRST with --no-deps
pip install --force-reinstall --no-deps Django==4.2.11

# 4. Then install other packages
pip install gunicorn==20.1.0
pip install psycopg2-binary==2.9.9
pip install whitenoise==6.6.0
pip install dj-database-url==2.1.0

# 5. Install Pillow with build isolation disabled
pip install Pillow==9.5.0 --no-build-isolation

# 6. Database setup
python manage.py makemigrations
python manage.py migrate

# 7. Static files
mkdir -p staticfiles
python manage.py collectstatic --noinput

# 8. Verification
echo "===== VERIFICATION ====="
python -c "from django.db.migrations import Migration; print('Migrations module working')"
python manage.py check --deploy