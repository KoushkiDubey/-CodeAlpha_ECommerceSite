#!/bin/bash
set -o errexit

#!/bin/bash
set -o errexit


#!/bin/bash
set -o errexit


apt-get update && \
apt-get install -y --no-install-recommends \
    libjpeg-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libwebp-dev || true

pip install --upgrade pip setuptools wheel
pip install Django==4.2.11
pip install gunicorn==20.1.0
pip install psycopg2-binary==2.9.9


pip install pillow==9.5.0 --no-build-isolation --ignore-installed


pip install whitenoise==6.6.0
pip install dj-database-url==2.1.0

python manage.py makemigrations
python manage.py migrate


python manage.py collectstatic --noinput


echo "===== PILLOW INSTALLED SUCCESSFULLY ====="
python -c "from PIL import Image; print(f'Pillow version: {Image.__version__}')"
