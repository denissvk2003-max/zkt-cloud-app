# Základný nginx image
FROM nginx:alpine

# envsubst je súčasť balíka gettext
RUN apk add --no-cache gettext

# Skopírovanie HTML stránky
COPY index.html /usr/share/nginx/html/index.html

# Skopírovanie nginx template konfigurácie
COPY default.conf.template /etc/nginx/templates/default.conf.template

# Frontend počúva na porte 80
EXPOSE 80

# Pri štarte sa do nginx konfigurácie doplní BACKEND_URL
CMD ["/bin/sh", "-c", "envsubst '$BACKEND_URL' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]