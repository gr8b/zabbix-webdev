### Web development environment

Clone Zabbix [repository](https://git.zabbix.com/scm/zbx/zabbix.git) to directory `zabbix` in user home directory.
As persistent storage of database containers `./docker-volume` directory is used.
Web server and PHP log files are stored in directory `zabbix/log` in user home directory.\
To define custom directories copy `.env.example` file to `.env` and make required changes to fit your needs.

### Start development environment

To start required environment use `--profile` options from table below.

|Profile key|Hostname|Service|Image|
|-----------|--------|-------|-----|
|apache  ||web server apache|[httpd:alpine](https://hub.docker.com/_/httpd)|
|nginx   ||web server nginx|[nginx:alpine](https://hub.docker.com/_/nginx)|
|phpfpm56|php|php 5.6|[Dockerfile/php5.6.Dockerfile](./Dockerfile/php5.6.Dockerfile)|
|phpfpm74|php|php 7.4|[Dockerfile/php7.4.Dockerfile](./Dockerfile/php7.4.Dockerfile)|
|phpfpm80|php|php 8.0|[Dockerfile/php8.0.Dockerfile](./Dockerfile/php8.0.Dockerfile)|
|phpfpm83|php|php 8.3|[Dockerfile/php8.3.Dockerfile](./Dockerfile/php8.3.Dockerfile)|
|mariadb |db |database mariadb|[mariadb:lts](https://hub.docker.com/_/mariadb)|
|mysql   |db |database mysql 8.2|[mysql:8.2](https://hub.docker.com/_/mysql)|
|mysql-legacy|db |database mysql 5.7|[mysql:5.7](https://hub.docker.com/_/mysql)|
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