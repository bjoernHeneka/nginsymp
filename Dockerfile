FROM php:7.1-fpm

EXPOSE 80
EXPOSE 443

RUN apt-get update && \
    echo 'deb http://packages.dotdeb.org jessie all' > /etc/apt/sources.list.d/dotdeb.list && \
    apt-get install -y apt-transport-https curl && \
    curl http://www.dotdeb.org/dotdeb.gpg | apt-key add - && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng12-dev \
    libcurl4-gnutls-dev \
    zlib1g-dev \
    libicu-dev \
    libmcrypt-dev \
    g++ \
    libxml2-dev \
    libldb-dev \
    libpq-dev \
    libldap2-dev \
    vim \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    ghostscript \
    libmagickwand-dev --no-install-recommends \
    nginx \
    cron && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/*

RUN ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
    && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so

RUN docker-php-ext-install -j$(nproc) pdo \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install -j$(nproc) bcmath \
    && docker-php-ext-install -j$(nproc) curl \
    && docker-php-ext-install -j$(nproc) mcrypt \
    && docker-php-ext-install -j$(nproc) exif \
    && docker-php-ext-install -j$(nproc) opcache \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) ldap \
    && docker-php-ext-install -j$(nproc) sockets \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install imagick  \
    && docker-php-ext-enable imagick

ADD config/nginx/nginx.conf /etc/nginx/
ADD config/nginx/symfony.conf /etc/nginx/sites-available/
ADD config/nginx/conf.d/upstream.conf /etc/nginx/conf.d/upstream.conf

ADD config/php/symfony.ini /etc/php/7.0/fpm/conf.d/
ADD config/php/symfony.ini /etc/php/7.0/cli/conf.d/

ADD config/php/symfony.pool.conf /etc/php/7.0/fpm//pool.d/
COPY config/php/php.ini /usr/local/etc/php/

RUN usermod -u 1000 www-data

ADD config/symfony/chall.sh /root/chall.sh
ADD start.sh /root/start.sh

RUN chmod +x /root/start.sh /root/chall.sh

RUN mkdir -p  /var/www/symfony
WORKDIR /var/www/symfony

RUN ln -s /etc/nginx/sites-available/symfony.conf /etc/nginx/sites-enabled/symfony \
    && rm /etc/nginx/sites-enabled/default


RUN mkdir -p /var/www/symfony/web/media/cache && \
    mkdir -p /var/www/symfony/var/cache  && \
    chmod 0755 /var/www/symfony -R && \
    chmod 0775 /var/www/symfony/web/media/cache/ -R && \
    chmod 0775 /var/www/symfony/var/ -R && \
    chown 1000.1000 -R /var/www/symfony

ENTRYPOINT ["/bin/bash", "/root/start.sh"]
