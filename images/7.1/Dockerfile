FROM php:7.1-fpm

RUN apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
        libz-dev \
        less \
        mysql-client \
    && docker-php-ext-install -j$(nproc) \
        mysqli \
        zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install xdebug \
    && docker-php-ext-enable gd mysqli zip xdebug \
    && apt-get remove -y build-essential libz-dev \
    && apt-get autoremove -y \
    && apt-get clean

RUN apt-get update && apt-get -y install libmemcached11 libmemcachedutil2 libmemcached-dev git \
    && mkdir -p /opt/memcached \
    && cd /opt/memcached \
    && git clone --branch php7 https://github.com/php-memcached-dev/php-memcached \
    && cd php-memcached \
    && phpize \
    && ./configure \
    && make \
    && mv /opt/memcached/php-memcached/modules/memcached.so /opt/memcached/memcached.so \
    && cd /opt/memcached \
    && rm -r php-memcached \
    && echo "extension=/opt/memcached/memcached.so" > /usr/local/etc/php/conf.d/memcached.ini \
    && apt-get remove -y build-essential libmemcached-dev libz-dev git \
    && apt-get autoremove -y \
    && apt-get clean

RUN curl https://getcomposer.org/download/$(curl -LSs https://api.github.com/repos/composer/composer/releases/latest | grep 'tag_name' | sed -e 's/.*: "//;s/".*//')/composer.phar > composer.phar \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

EXPOSE 9000

CMD ["php-fpm"]
