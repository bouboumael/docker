#!/bin/sh

## Symfony cconfiguration
php bin/console doctrine:database:create --if-not-exists --quiet --no-interaction
php bin/console doctrine:migrations:migrate --verbose --no-interaction --allow-no-migration

php bin/console cache:clear
php bin/console cache:warmup

chmod -R 777 /var
chmod -R 777 /public

## server config
php-fpm &
nginx -g "daemon off;"