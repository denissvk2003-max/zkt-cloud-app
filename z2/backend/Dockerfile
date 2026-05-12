# Základný Python image
FROM python:3.11-slim
# Pracovný priečinok aplikácie
WORKDIR /app

# Kopírovanie requirements súboru
COPY requirements.txt .
# Inštalácia Python knižníc
RUN pip install --no-cache-dir -r requirements.txt

# Kopírovanie backend aplikácie
COPY app.py .
# Backend bude počúvať na porte 5000
EXPOSE 5000
# Spustenie Flask aplikácie
CMD ["python", "app.py"]