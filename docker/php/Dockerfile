FROM php:8.0.11-fpm

LABEL maintainer="PuddingLab"

ARG GIT_MAIL
ARG GIT_USERNAME

WORKDIR /application
COPY ./ /application/

RUN apt update \
    && apt install -y zlib1g-dev g++ git libicu-dev zip libzip-dev zip \
    && docker-php-ext-install intl opcache pdo pdo_mysql \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

RUN git config --global user.email ${GIT_MAIL} \
    && git config --global user.name ${GIT_USERNAME}

#COPY ./composer.lock ./composer.json /application/
RUN composer install --prefer-dist && composer dump-autoload


#RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
#RUN apt-get update && apt-get install -y nodejs
#RUN npm install npm@latest -g
#RUN npm install yarn@latest -g
#RUN npm -v
#RUN node -v

COPY ./docker/php/docker-entry.sh /
RUN chmod +x /docker-entry.sh
ENTRYPOINT [ "/docker-entry.sh" ]
