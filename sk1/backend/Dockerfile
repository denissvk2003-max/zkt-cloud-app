# Základný Python image pre backend aplikáciu
FROM python:3.11-slim

# Pracovný priečinok v kontajneri
WORKDIR /app

# Kopírovanie zoznamu Python závislostí
COPY requirements.txt .

# Inštalácia potrebných Python knižníc
RUN pip install --no-cache-dir -r requirements.txt

# Kopírovanie backend aplikácie
COPY app.py .

# Backend počúva na porte, ktorý nastaví Render cez premennú PORT
EXPOSE 5000

# Spustenie backendu cez Gunicorn server
CMD ["sh", "-c", "gunicorn -b 0.0.0.0:${PORT:-5000} app:app"]