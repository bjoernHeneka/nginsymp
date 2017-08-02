#!/bin/bash

# start cronjob scheduler
/etc/init.d/cron start

# start fpm as daemon
php-fpm -D

# clear caches
/root/chall.sh

# Start nginx as master priocess in foreground
nginx -g 'daemon off;'