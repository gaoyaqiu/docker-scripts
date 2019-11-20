# Gitlab
## 安装
```shell
cd gitlab
docker-compose up -d
```
启动好之后，访问：http://192.168.0.132:8899 会提示需要设置 root 密码，设置完之后就可以登录了。

## 备份与恢复
> 新的 gitlab 版本必须要和备份的那个 gitlab 版本一致，否则报如下错误

```
GitLab version mismatch:
  Your current GitLab version (12.4.3) differs from the GitLab version in the backup!
  Please switch to the following version and try again:
  version: 11.3.0-ee


Hint: git checkout v11.3.0-ee
```

### 备份
#### 手动备份
在 gitlab 服务器上执行如下命令进行备份
```
gitlab-rake gitlab:backup:create
```
执行完成之后会在，备份文件存放在 gitlab 的 data/backup/ 目录下，如：`1574241568_2019_11_20_11.3.0-ee_gitlab_backup.tar`
#### 定时备份

* 将备份的定时任务加入到 crontab 中

```
crontab -e
// 设置以下命令
0 1 * * * /usr/bin/docker exec -it gitlab gitlab-rake gitlab:backup:create
```
* 重新加载 crontab
```
/sbin/service crond reload
```
但是在生产环境中的话，对于定时任务可能需要记录下执行日志，否则也不知道任务执行情况，我这边给个简单的脚本供参考:
```
#!/bin/bash

time=$(date "+%Y-%m-%d %H:%M:%S")

/usr/bin/docker exec -it gitlab gitlab-rake gitlab:backup:create
echo -e $time "备份 gitlab 代码结束\n" >> /data/apps/gitlab/script/gitlab-backup-log
```
然后 crontab 修改如下
```
0 2 * * * /data/apps/gitlab/script/gitlab.backup > /dev/null 2>&1 &
```
> 别忘了要 reload

### 恢复
将备份文件拷贝到 gitlab 新服务器对应的 backup 下，然后在新服务下执行如下命令来恢复
```
docker exec -it gitlab gitlab-rake gitlab:backup:restore BACKUP=1574241568_2019_11_20_11.3.0-ee
```
> 1574241568_2019_11_20_11.3.0-ee 为备份之后的唯一版本号

## 将工程代码更新为新的 gitlab 仓库地址
* 修改远程仓库地址
```
git remote set-url origin 新的仓库地址
```
最后提交代码试下吧。
