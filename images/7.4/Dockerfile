# -stretch added to work around this issue with freetype: https://github.com/docker-library/php/issues/865
FROM php:7.4-fpm

RUN set -eux \
    && apt-get update \
    && echo "postfix postfix/mailname string example.com" | debconf-set-selections \
    && echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections \
    && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libz-dev \
        less \
        postfix \
        default-mysql-client \
        libmemcached11 \
        libmemcachedutil2 \
        libmemcached-dev \
        libzip-dev \
    && docker-php-ext-install -j$(nproc) \
        mysqli \
        pdo_mysql \
        sockets \
        zip \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install \
        xdebug \
        memcached \
    && docker-php-ext-enable xdebug memcached \
    && apt-get remove -y build-essential libz-dev libmemcached-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && curl https://getcomposer.org/download/latest-2.x/composer.phar > composer.phar
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

EXPOSE 9000

CMD ["php-fpm"]
