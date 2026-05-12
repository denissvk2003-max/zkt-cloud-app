# Základný nginx image pre frontend
FROM nginx:alpine

# Inštalácia gettext kvôli envsubst
RUN apk add --no-cache gettext

# Skopírovanie HTML stránky do nginx priečinka
COPY index.html /usr/share/nginx/html/index.html

# Skopírovanie nginx konfiguračnej šablóny
COPY default.conf.template /etc/nginx/templates/default.conf.template

# Frontend počúva na porte 80
EXPOSE 80

# Pri štarte sa doplní PORT a BACKEND_URL do nginx konfigurácie
# a následne sa spustí nginx server
CMD ["/bin/sh", "-c", "envsubst '$PORT $BACKEND_URL' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]