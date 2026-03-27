FROM php:8.1-apache

RUN apt-get update && apt-get install -y libpng-dev \
    && docker-php-ext-install gd

# Fix "More than one MPM loaded" — ensure only prefork is active (required by mod_php)
RUN rm -f /etc/apache2/mods-enabled/mpm_event.load /etc/apache2/mods-enabled/mpm_event.conf \
    /etc/apache2/mods-enabled/mpm_worker.load /etc/apache2/mods-enabled/mpm_worker.conf \
    && a2enmod mpm_prefork 2>/dev/null || true
RUN a2enmod rewrite

WORKDIR /var/www/html

COPY . .

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

# Railway sets $PORT — configure Apache to listen on it
RUN sed -i 's/Listen 80/Listen ${PORT}/' /etc/apache2/ports.conf \
    && sed -i 's/<VirtualHost \*:80>/<VirtualHost *:${PORT}>/' /etc/apache2/sites-available/000-default.conf

CMD ["apache2-foreground"]

