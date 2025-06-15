# E-Commerce Site

## Setup
```bash
pip install -r requirements.txt
python manage.py migrate
python manage.py createsuperuser --username codealpha --email review@codealpha.com  # Password: CodeAlpha@123
python manage.py loaddata categories products
python manage.py runserver
