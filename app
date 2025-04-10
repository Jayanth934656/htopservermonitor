import os
import subprocess
import pytz
from datetime import datetime
from django.conf import settings
from django.http import HttpResponse
from django.urls import path
from django.core.management import execute_from_command_line

# Django settings in code
settings.configure(
    DEBUG=True,
    ROOT_URLCONF=__name__,
    SECRET_KEY='your-secret-key',
    ALLOWED_HOSTS=['*'],
    MIDDLEWARE=[],
)

# htop view
def htop_view(request):
    full_name = "John Doe"  # Replace with your full name

    try:
        username = os.getlogin()
    except Exception:
        username = os.environ.get("USER", "unknown")

    ist = pytz.timezone('Asia/Kolkata')
    ist_time = datetime.now(ist).strftime('%Y-%m-%d %H:%M:%S')

    try:
        top_output = subprocess.check_output(['top', '-b', '-n', '1'], stderr=subprocess.STDOUT).decode('utf-8')
        top_lines = "\n".join(top_output.splitlines()[:20])
    except Exception as e:
        top_lines = f"Error getting top output: {e}"

    html = f"""
    <h1>/htop Monitor (Django)</h1>
    <pre>
Name: {full_name}
Username: {username}
Server Time (IST): {ist_time}

--- Top Output (first 20 lines) ---
{top_lines}
    </pre>
    """
    return HttpResponse(html)

# URL patterns
urlpatterns = [
    path("htop", htop_view),
]

# Runserver if executed directly
if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "__main__")
    execute_from_command_line(["manage.py", "runserver", "0.0.0.0:8000"])
