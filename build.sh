#!/bin/bash
set -o errexit

#!/bin/bash
set -o errexit

# 1. Clean environment and force Django reinstallation
#!/bin/bash
set -o errexit

# 1. System dependencies for Pillow (without sudo)
apt-get update && \
apt-get install -y --no-install-recommends \
    libjpeg-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libwebp-dev || true

# 2. Install Python packages in correct order
pip install --upgrade pip setuptools wheel
pip install Django==4.2.11
pip install gunicorn==20.1.0
pip install psycopg2-binary==2.9.9
pip install whitenoise==6.6.0
pip install dj-database-url==2.1.0

# 3. Install Pillow with workaround
pip install --pre pillow==9.5.0 --no-build-isolation

# 4. Database setup
python manage.py makemigrations
python manage.py migrate

# 5. Static files
python manage.py collectstatic --noinput

# 6. Verification
echo "===== PILLOW INSTALLED SUCCESSFULLY ====="
python -c "from PIL import Image; print(f'Pillow version: {Image.__version__}')"