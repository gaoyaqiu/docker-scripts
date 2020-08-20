#!/bin/bash

echo > /var/log/syslog  # 记录系统日志的服务
echo > /var/log/messages
echo > /var/log/xferlog
echo > /var/log/secure # 登录信息
echo > /var/log/auth.log
echo > /var/log/user.log
echo > /var/log/wtmp # 清除用户登录记录
echo > /var/log/lastlog # 清除最近登录信息
echo > /var/log/btmp # 清除尝试登录记录
echo > /var/run/utmp
cat /dev/null > /var/adm/sylog
cat /dev/null > /var/log/maillog
cat /dev/null > /var/log/openwebmail.log
cat /dev/null > /var/log/mail.info
echo > ~/.bash_history
history -cw