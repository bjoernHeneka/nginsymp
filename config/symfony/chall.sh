#!/bin/bash

rm -rf /var/www/symfony/web/media/cache/*
rm -rf /var/www/symfony/var/cache/*
php /var/www/symfony/bin/console cache:clear --env=dev --no-warmup
php /var/www/symfony/bin/console cache:clear --env=prod --no-warmup
php /var/www/symfony/bin/console cache:warmup --env=dev
php /var/www/symfony/bin/console cache:warmup --env=prod
chmod 0775 /var/www/symfony/{vendor,app,src} -R
chown 1000.1000 /var/www/symfony/ -R