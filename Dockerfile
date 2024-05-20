# Use the official PHP image as the base image
FROM php:8.1-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpq-dev \
    libicu-dev \
    libzip-dev \
    zip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd intl zip pdo pdo_mysql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set the working directory
WORKDIR /var/www/html

# Copy the existing application directory contents
COPY . .

# Install Symfony dependencies
RUN composer install

# Set permissions for the Symfony var directory
RUN chown -R www-data:www-data var

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
