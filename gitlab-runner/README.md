# docker 方式安装
```
docker run -dit \
--name gitlab-runner \
--restart always \
-v /data/apps/gitlab-runner/config:/etc/gitlab-runner \
-v /var/run/docker.sock:/var/run/docker.sock \
gitlab/gitlab-runner:latest
```

# 注册
```
docker exec gitlab-runner gitlab-runner register -n \
       --url http://192.168.88.3/ \
       --registration-token JBsEnXPs7zEuLQj91aC5 \
       --tag-list runInDk \
       --executor docker \
       --docker-image docker \
       --docker-volumes /var/run/docker.sock:/var/run/docker.sock \
       --description "runInDk"
```

# 配置
1. gitlab-runner 配置ssh
进入容器创建ssh密钥对，将公钥拷贝到待部署的机器`~/.ssh/authorized_keys`中，最后在用ssh连接测试下
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
`SSH_PRIVATE_KEY`、`SSH_KNOWN_HOSTS` 两个变量
也就是步骤一中创建的私钥及known_hosts文件内容

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

