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
在 gitlab 服务器上执行如下命令进行备份(非 docker 安装)
```
gitlab-rake gitlab:backup:create
```
如果是 docker 安装的 gitlab 请通过 docker 命令来执行，如：
```
docker exec -it gitlab gitlab-rake gitlab:backup:create
```
执行完成之后，备份文件存放在 gitlab 的 data/backup/ 目录下，如：`1574241568_2019_11_20_11.3.0-ee_gitlab_backup.tar`，不知道 data 目录在哪的也没关系，直接通过文件名搜一下就行了。
#### 定时备份

* 将备份的定时任务加入到 crontab 中

```
crontab -e
// 设置以下命令
0 1 * * * /usr/bin/docker exec -it gitlab gitlab-rake gitlab:backup:create
```
* 重启 crontab

```
 systemctl restart crond
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
0 2 * * * /data/apps/gitlab/script/gitlab-backup.sh > /dev/null 2>&1 &
```
需要给文件添加执行权限
```
chmod +x /data/apps/gitlab/script/gitlab-backup.sh
```
别忘了重启 crontab
```
systemctl restart crond
```

### 恢复
将备份文件拷贝到 gitlab 新服务器对应的 backup 下，然后在新服务下执行如下命令来恢复
```
docker exec -it gitlab gitlab-rake gitlab:backup:restore BACKUP=1574241568_2019_11_20_11.3.0-ee
```
> 1574241568_2019_11_20_11.3.0-ee 为备份之后的唯一版本号，非 docker 安装的话，直接在服务器上执行 `gitlab-rake gitlab:backup:restore BACKUP=1574241568_2019_11_20_11.3.0-ee` 即可

## 将工程代码更新为新的 gitlab 仓库地址
* 修改远程仓库地址
```
git remote set-url origin 新的仓库地址
```
最后提交代码试下吧。

## 邮件测试
### 发送邮件
* 进入 gitlab 服务器，或者 docker 容器，进入控制台
```
gitlab-rails console
```
* 发送测试邮件
```
Notify.test_email('接收方邮件地址','邮件标题','邮件内容').deliver_now
```
### 发送邮件错误问题排查
* 进入控制台
```
gitlab-rails console production
```
* 查看 method 是否为 :smtp
```
ActionMailer::Base.delivery_method
```
* 查看邮件配置是否正确
```
ActionMailer::Base.smtp_settings
```
> 一般都是配置错误，修正即可

## Gitlab 文件迁移问题
如果将 `config`、`data`、`logs` 三个文件夹拷贝到新的目录，在启动会报权限相关错误
解决：
在 gitlab 启动之后，输入如下操作
```
docker exec -it gitlab update-permissions
docker exec -it gitlab chmod -R 0770 /var/opt/gitlab/git-data
docker exec -it gitlab chmod -R 2770 /var/opt/gitlab/git-data/repositories
// 最后在重启
docker restart gitlab
```
再次启动发现又有下面错误
```
// 省略其它内容
open /var/opt/gitlab/alertmanager/data/nflog: permission denied"
```
解决：
1. 进入`data` 目录
```
chown 992:root alertmanager/
```
2. 进入 `alertmanager` 目录
```
chown 992:root alertmanager.yml
chown -R 992:992 data/
```

## 参考
* [install-gitlab-using-docker-compose](https://docs.gitlab.com/omnibus/docker/#install-gitlab-using-docker-compose "install-gitlab-using-docker-compose")