#!/bin/bash

/etc/init.d/cron start
#crontab -u root /etc/cron.d/cron-jobs
#/etc/init.d/cron -f
tail -f /dev/null