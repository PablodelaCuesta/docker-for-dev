FROM php:7.1-apache

RUN docker-php-ext-install mbstring mysqli

# allow .htaccess with RewriteEngine
RUN a2enmod rewrite

ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf


EXPOSE 80

# start Apache2 on image start
CMD ["/usr/sbin/apache2ctl","-DFOREGROUND"]