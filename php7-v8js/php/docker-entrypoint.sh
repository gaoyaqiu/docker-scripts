#!/bin/bash
/etc/init.d/cron start
php-fpm
tail -f /dev/null