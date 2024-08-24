FROM composer:2.6.6 AS composer

FROM php:7.4-fpm
RUN pecl install xdebug-3.1.6
RUN docker-php-ext-enable xdebug

RUN apt-get update && apt-get install -y \
    libfreetype-dev \
    libjpeg62-turbo-dev \
    libpng-dev
RUN docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-install -j$(nproc) bcmath

RUN docker-php-ext-configure ctype --enable-ctype \
    && docker-php-ext-install -j$(nproc) ctype

RUN docker-php-ext-configure sockets --enable-sockets \
    && docker-php-ext-install -j$(nproc) sockets

RUN docker-php-ext-configure gettext --with-gettext \
    && docker-php-ext-install -j$(nproc) gettext

RUN apt-get update && \
    apt-get install libldap2-dev -y && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap

RUN docker-php-ext-install -j$(nproc) mysqli

RUN apt-get install -y libpq-dev \
    && docker-php-ext-install pgsql

RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini \
    && sed -i 's/post_max_size = 8M/post_max_size = 128M/g' /usr/local/etc/php/php.ini \
    && sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /usr/local/etc/php/php.ini \
    && sed -i 's/max_input_time = 60/max_input_time = 300/g' /usr/local/etc/php/php.ini \
	&& sed -i 's/;date\.timezone =/date\.timezone = "Europe\/Riga"/' /usr/local/etc/php/php.ini

RUN apt-get update && apt-get install -y locales
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8 && locale-gen en_GB.UTF-8

RUN useradd zabbix
RUN usermod -a -G zabbix www-data

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

RUN curl -LO https://phar.phpunit.de/phpunit-8.5.phar
RUN chmod +x phpunit-8.5.phar && mv phpunit-8.5.phar /usr/local/bin/phpunit

RUN apt-get update && apt-get install -y unzip
RUN composer global require phpunit/phpunit-selenium:^8.0 facebook/webdriver:dev-master
RUN sed -i 's/memory_limit = 128M/memory_limit = 1G/g' /usr/local/etc/php/php.ini
RUN apt-get update && apt-get install -y gzip default-mysql-client wget gnupg2

RUN apt-get update && apt-get install -y lsb-release && apt-get clean all
RUN sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-client-16
