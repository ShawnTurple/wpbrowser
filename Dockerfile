FROM php:7.2-cli

MAINTAINER Shawn Turple shawn.turple@gov.bc.ca

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH /repo:${PATH}

# Install required system packages
RUN 	apt-get update && apt-get -y install \
	git zlib1g-dev libssl-dev libpng-dev  less vim graphviz libicu-dev zlib1g-dev libxslt1-dev\
	--no-install-recommends && apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install php extensions
RUN 	docker-php-ext-install bcmath zip gd pdo_mysql mysqli intl xsl; \
	pecl install mongodb xdebug-2.6.0beta1 && \
	docker-php-ext-enable mongodb.so xdebug ;

# Configure php
RUN echo "date.timezone = UTC" >> /usr/local/etc/php/php.ini

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- \
	--filename=composer \
	--install-dir=/usr/local/bin; \
	composer global require --optimize-autoloader "hirak/prestissimo";

# Prepare application
WORKDIR /repo

ADD ./composer.json /repo/composer.json

# Install vendor
RUN 	composer install --prefer-dist --optimize-autoloader; \
	ln -s /repo/vendor/bin/codecept /usr/local/bin/codecept; \
	mkdir -p  /wordpress /project

RUN  sed -i -e "s/\.env/\.\.\/env\/\.env/" /repo/vendor/lucatume/wp-browser/codeception.dist.yml
ADD docker-entrypoint.sh /usr/local/bin
ADD phpcs.xml /
ADD Wpbrowser.php /repo/vendor/lucatume/wp-browser/src/Codeception/Template/

RUN 	ln -s /repo/vendor/bin/phpcs /usr/local/bin/phpcs; \
	ln -s /repo/vendor/bin/phpcbf /usr/local/bin/phpcbf; \
	ln -s /repo/vendor/bin/phpdoc /usr/local/bin/phpdoc; \
	ln -s /repo/vendor/bin/jsonlint /usr/local/bin/jsonlint; \
	ln -s /repo/vendor/bin/validate-json /usr/local/bin/validate-json; \
	chmod +x /usr/local/bin/* ; \
	chown -R www-data:www-data /repo;

WORKDIR /project

USER www-data

ENTRYPOINT ["docker-entrypoint.sh"]
#ENTRYPOINT ["/repo/vendor/bin/codecept"]
#ENTRYPOINT ["bash"]
