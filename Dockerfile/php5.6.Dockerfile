FROM php:5.6-fpm

RUN sed -i -e 's/deb.debian.org/archive.debian.org/g' \
           -e 's|security.debian.org|archive.debian.org/|g' \
           -e '/stretch-updates/d' /etc/apt/sources.list

RUN apt-get update && apt-get install -y libfreetype6-dev libgd-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr
RUN docker-php-ext-install gd

RUN docker-php-ext-install opcache
RUN pecl install xdebug-2.5.5 && docker-php-ext-enable xdebug

RUN docker-php-ext-configure bcmath --enable-bcmath && docker-php-ext-install -j$(nproc) bcmath
RUN docker-php-ext-configure ctype --enable-ctype && docker-php-ext-install -j$(nproc) ctype
RUN docker-php-ext-configure sockets --enable-sockets && docker-php-ext-install -j$(nproc) sockets
RUN docker-php-ext-configure gettext --with-gettext && docker-php-ext-install -j$(nproc) gettext

RUN apt-get update && \
    apt-get install libldap2-dev -y && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap

RUN docker-php-ext-install -j$(nproc) mysqli mysql
RUN docker-php-ext-enable mysql

RUN apt-get install -y libpq-dev && docker-php-ext-install pgsql

RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini \
    && sed -i 's/post_max_size = 8M/post_max_size = 128M/g' /usr/local/etc/php/php.ini \
    && sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /usr/local/etc/php/php.ini \
    && sed -i 's/max_input_time = 60/max_input_time = 300/g' /usr/local/etc/php/php.ini \
    && sed -i 's/;date\.timezone =/date\.timezone = "Europe\/Riga"/' /usr/local/etc/php/php.ini \
    && echo "always_populate_raw_post_data = -1" >> /usr/local/etc/php/php.ini

RUN apt-get update && apt-get install -y locales
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8 && locale-gen en_GB.UTF-8

RUN useradd zabbix
RUN usermod -a -G zabbix www-data
