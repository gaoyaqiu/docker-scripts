# docker 方式安装
```
docker run -dit \
--name gitlab-runner \
--restart always \
-v /data/apps/gitlab-runner/config:/etc/gitlab-runner \
-v /var/run/docker.sock:/var/run/docker.sock \
gitlab/gitlab-runner:latest
```

# docker-compose 方式安装
```
docker-compose up -d --build
```

# 注册
```
[root@iZbp1adzdewrn6h8agutzfZ ~]# docker exec -it gitlab-runner bash
root@9f8f80cd2824:/# gitlab-runner register
Running in system-mode.                            
                                                   
Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/):
http://x.x.x.x:x/
Please enter the gitlab-ci token for this runner:
xxxxxxxxxxxxx
Please enter the gitlab-ci description for this runner:
[9f8f80cd2824]: demo-test
Please enter the gitlab-ci tags for this runner (comma separated):
demo-test
Registering runner... succeeded                     runner=PT4sT2zx
Please enter the executor: parallels, shell, ssh, docker-ssh+machine, kubernetes, docker, docker-ssh, virtualbox, docker+machine:
docker
Please enter the default Docker image (e.g. ruby:2.1):
kevinyan001/git-runner:php7.1-node10
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded! 
```
> 在gitlab的CI/CD > Runners 下拷贝以上参数
> 注： 建议把 "为该项目启用共享Runner" 选项取消掉，否则其他同事可能执行不了任务（不清楚为啥，我这边是取消勾选，其他同事推送代码之后Runner才能正常执行）

# 配置
1. gitlab-runner 配置ssh

> 需要切换到 gitlab-runner 用户 `su gitlab-runner`

切换到 gitlab-runner 用户之后，生成 ssh 密钥对，将公钥拷贝到待部署(也就是宿主机)的机器`~/.ssh/authorized_keys`中，最后在用ssh连接测试下
```
gitlab-runner@9f8f80cd2824:/$ ssh root@x.x.x.x
The authenticity of host 'x.x.x.x (x.x.x.x)' can't be established.
ECDSA key fingerprint is SHA256:KiuHCE9sSKC8xNry0THQSeGeyMAt+t3xXDEYkc7aqEw.
Are you sure you want to continue connecting (yes/no)? `yes`
Warning: Permanently added 'x.x.x.x' (ECDSA) to the list of known hosts.
Last login: Sun Aug 23 17:19:57 2020 from x.x.x.x

Welcome to Alibaba Cloud Elastic Compute Service !
```

2. 在gitlab的CI/CD中配置环境变量
Settings > CI/CD > Variables 添加：
`SSH_PRIVATE_KEY`、`SSH_KNOWN_HOSTS`、`SSH_SERVER` 三个变量
> SSH_PRIVATE_KEY: gitlab-runner 用户生成的 ssh私钥文件中的内容
> known_hosts: gitlab-runner 用户使用 ssh root@x.x.x.x 之后生成的内容
> SSH_SERVER: 是为了`rsync`传文件到宿主机服务器上的，如：root@x.x.x.x 
> 注：需要把标记下的 保护变量 取消勾选

3. 测试脚本如下：
```
stages:
  - deploy-test
before_script:
    - mkdir -p ~/.ssh
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r'  > /root/.ssh/id_rsa
    - chmod -R 600 ~/.ssh
    - echo "$SSH_KNOWN_HOSTS" > ~/.ssh/known_hosts
    - chmod 644 ~/.ssh/known_hosts

deploying_test:
  stage: deploy-test
  script:
    - echo "deploying test..."
    - rsync -az --delete --exclude=.git --exclude=.gitignore --exclude=.gitlab-ci.yml ./ root@x.x.x.x:/data/apps/epay/epay/
  only:
    - master
  tags:
    - epay-test
```

