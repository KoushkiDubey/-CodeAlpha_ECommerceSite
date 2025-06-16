#!/bin/bash
set -e
#!/bin/bash
set -e

# 1. Ensure migrations are applied
python manage.py migrate

# 2. Only needed if you changed from SQLite to PostgreSQL
python manage.py makemigrations --noinput

# 3. Create cache tables if using database cache
python manage.py createcachetable

# 4. Collect static files
python manage.py collectstatic --noinput

# 5. Start Gunicorn
exec gunicorn ecommerce_project.wsgi:application --bind 0.0.0.0:$PORT