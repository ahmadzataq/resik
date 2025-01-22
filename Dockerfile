FROM php:7.4-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring exif bcmath gd

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy project files
COPY . .

# Install Laravel dependencies
RUN composer install --optimize-autoloader --no-dev

# Permissions for storage and cache
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Expose PHP-FPM port
EXPOSE 9000

CMD ["php-fpm"]
