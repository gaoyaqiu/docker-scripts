#!/bin/bash

mkdir -p /data/logs/backup/

start_time=$(date "+%Y-%m-%d %H:%M:%S")
echo -e $start_time "备份 gitlab 代码---开始" >>/data/logs/backup/gitlab-backup.log
/usr/bin/docker exec -it gitlab gitlab-rake gitlab:backup:create

end_time=$(date "+%Y-%m-%d %H:%M:%S")
echo -e $end_time "备份 gitlab 代码---结束\n" >>/data/logs/backup/gitlab-backup.log
