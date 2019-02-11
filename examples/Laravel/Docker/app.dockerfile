FROM php:7.3.2-fpm

RUN apt-get update && apt-get install -y libmcrypt-dev \
    mysql-client libmagickwand-dev --no-install-recommends

RUN pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install pdo_mysql