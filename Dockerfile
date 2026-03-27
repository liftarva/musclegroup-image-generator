FROM php:8.1-cli

RUN apt-get update && apt-get install -y libpng-dev \
    && docker-php-ext-install gd \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

COPY . .

EXPOSE 8080

CMD php -S 0.0.0.0:${PORT:-8080} index.php
