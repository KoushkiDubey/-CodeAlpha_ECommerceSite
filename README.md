# E-Commerce Site

## Setup
```bash
pip install -r requirements.txt
python manage.py migrate
python manage.py createsuperuser --username codealpha --email review@codealpha.com  # Password: CodeAlpha@123
python manage.py loaddata users categories products cart_orders
python manage.py runserver
## Live Site
➡️ [View Live Site](https://koushki.pythonanywhere.com)
🔐 Test Admin Access
Username: admin
Password: CodeAlpha@123
