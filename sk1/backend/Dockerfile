# Základný Python image
FROM python:3.11-slim

# Pracovný priečinok v kontajneri
WORKDIR /app

# Skopírovanie závislostí
COPY requirements.txt .

# Inštalácia Python balíkov
RUN pip install --no-cache-dir -r requirements.txt

# Skopírovanie aplikácie
COPY app.py .

# Backend počúva na porte 5000
EXPOSE 5000

# Spustenie aplikácie cez gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]