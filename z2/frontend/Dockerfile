# Základný nginx image
FROM nginx:alpine

# Kopírovanie HTML stránky
COPY index.html /usr/share/nginx/html/index.html
# Kopírovanie nginx konfigurácie
COPY default.conf /etc/nginx/conf.d/default.conf

# Frontend beží na porte 80
EXPOSE 80