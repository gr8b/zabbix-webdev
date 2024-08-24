### Web development environment

|Profile key|Hostname|Service|Image|
|-----------|--------|-------|-----|
|apache  ||web server apache|httpd:alpine|
|nginx   ||web server nginx|nginx:alpine|
|phpfpm56|php|php 5.6|Dockerfile/php5.6.Dockerfile|
|phpfpm74|php|php 7.4|Dockerfile/php7.4.Dockerfile|
|phpfpm80|php|php 8.0|Dockerfile/php8.0.Dockerfile|
|phpfpm83|php|php 8.3|Dockerfile/php8.3.Dockerfile|
|mariadb |db |database mariadb|mariadb:lts|
|mysql   |db |database mysql 8.2|mysql:8.2|
|mysql-legacy|db |database mysql 5.7|mysql:5.7|
|postgres|db |_(TBD)_||
|saml    |saml|_(TBD)_||
|ldap    |ldap|_(TBD)_||

Example: _start nginx webserver with php 8.3 and mysql 8.2_

```sh
docker-compose --profile nginx --profile phpfpm83 --profile mysql up
```

### Legacy frontend version support

For Zabbix version up to 4.4 PHP 5.6 and mysql 5.7 are required. To start legacy dev environment run:

```sh
docker-compose --profile nginx --profile phpfpm56 --profile mysql-legacy up
```