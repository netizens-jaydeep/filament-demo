FROM php:8.3

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libonig-dev \
    unzip \
    curl \
    git \
    libicu-dev \
    libxml2-dev \
    zlib1g-dev \
    libxslt1-dev \
    libjpeg62-turbo-dev \
    libwebp-dev \
    libxpm-dev \
    libvpx-dev \
    nodejs \
    gnupg \
    && docker-php-ext-install \
        pdo_mysql \
        mbstring \
        zip \
        intl \
        exif \
        pcntl \
    && apt-get clean

# Install Node.js 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
    -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Build frontend assets
RUN npm install && npm run build

# Generate app key
RUN php artisan key:generate

EXPOSE 8000

# JSON CMD to avoid signal issues
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
