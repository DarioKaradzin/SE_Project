FROM php:8.0-apache
WORKDIR /

# Copy files to root (not recommended)
COPY . .

# Install extensions
RUN apt update && apt install -y zip libzip-dev && docker-php-ext-install pdo_mysql zip

# Override Apache's default directory
ENV APACHE_DOCUMENT_ROOT /
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev

EXPOSE 80