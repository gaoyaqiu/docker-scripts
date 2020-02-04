# jenkins
## 以docker方式安装
```shell
cd jenkins
docker-compose -f jenkins.yml up -d
```
执行完发现报错
```shell
touch: cannot touch '/var/jenkins_home/copy_reference_file.log': Permission denied
Can not write to /var/jenkins_home/copy_reference_file.log. Wrong volume permissions?
```
是因为本地目录拥有者为`root`用户, 而容器中jenkins内部用的是uid=1000 的user，执行如下命令
```shell
root@piwik:/data/apps/jenkins# chown -R 1000 /data/apps/jenkins/jenkins_home/
root@piwik:/data/apps/jenkins# ll
total 16
drwxr-xr-x 3 root  root 4096 Apr  5 05:22 ./
drwxr-xr-x 4 root  root 4096 Apr  5 05:20 ../
drwxrwxrwx 2 piwik root 4096 Apr  5 05:22 jenkins_home/
-rw-r--r-- 1 root  root  519 Apr  5 05:22 jenkins.yml
root@piwik:/data/apps/jenkins# docker-compose -f jenkins.yml up -d
Creating jenkins_jenkins_1 ... done
root@piwik:/data/apps/jenkins# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                               NAMES
ad748c1e159c        jenkins:latest      "/bin/tini -- /usr/l…"   3 seconds ago       Up 2 seconds        0.0.0.0:50000->50000/tcp, 0.0.0.0:49001->8080/tcp   jenkins_jenkins_1
```
### 访问
访问之前首先查看管理员密码

```shell
root@piwik:/data/apps/jenkins# docker logs -f ad748c1e159c
// 此处只关注重要部分 edd0edbb33fd42b398d779074ecd45e4 就是管理员密码
Apr 05, 2019 5:39:54 AM jenkins.install.SetupWizard init
INFO: 

*************************************************************
*************************************************************
*************************************************************

Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

edd0edbb33fd42b398d779074ecd45e4

This may also be found at: /var/jenkins_home/secrets/initialAdminPassword

*************************************************************
*************************************************************
*************************************************************
```

访问：http://localhost:49001/， 之后粘贴管理员密码`edd0edbb33fd42b398d779074ecd45e4` , 选择`安装推荐的插件`继续安装, 最后创建账号/密码：admin/admin

### 忘记密码

修改jenkins_home/users/admin_xxx/config.xml

```shell
vi /data/apps/jenkins/jenkins_home/users/admin_2382922178606610043/config.xml
// 主要修改<passwordHash>中间数据</passwordHash>
<passwordHash>#jbcrypt:$2a$10$DdaWzN64JgUtLdvxWIflcuQu2fgrrMSAMabF5TSrGK5nXitqK9ZMS</passwordHash>
```

保存重启jenkins之后，就可以使用 111111 登录了。

### 安装自定义插件

* Git Parameter
* Extended Choice Parameter
* Gitlab
* Ansible
* Kubernetes
* Kubernetes Continuous Deploy

### 遇到的一些问题
1. 在jenkins中运行docker时候，提示 "error while loading shared libraries: libltdl.so.7: cannot open shared object file: No such file or directory"
解决：
    需要在容器启动时挂载`/usr/lib/x86_64-linux-gnu/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7`, 网上还有一种做法是基于官方的jenkins重新编译来安装`libltdl`，这种做法会对原生镜像造成污染，不建议使用。

2. 容器中的jenkins执行docker命令提示 docker not found
解决：
    原因是通过apt/yum安装的docker采用的是动态链接编译的，还依赖其它的so文件，并没有都mount到容器中，所以在jenkis容器中调用不到宿主机的docker命令, 需要通过源码重新安装docker即可: https://docs.docker.com/install/linux/docker-ce/binaries/
3. 当容器中的 jenkins 需要使用 Ansible 进行自动化部署时，发现无法挂载宿主机上的 ansible
解决：
   在 jenkins 容器中安装了 ansible 之后，重新打包新的镜像，后面使用新的镜像即可, 但是在使用 Ansible 作为自动化工具时，需要在部署的机器上安装 Python 的 Docker 依赖库，否则报如下错误
   ```
      Failed to import the required Python library (Docker SDK for Python: docker (Python >= 2.7) or docker-py (Python 2.6)) on gagago's Python /usr/bin/python. Please read module documentation and install in the appropriate location. If the required library is installed, but Ansible is using the wrong Python interpreter, please consult the documentation on ansible_python_interpreter, for example via `pip install docker` or `pip install docker-py` (Python 2.6). The error was: No module named requests.exceptions"}
   ```
安装命令如下：

```
yum -y install epel-release
yum -y install python-pip
pip install --upgrade pip
pip install docker -i https://pypi.doubanio.com/simple/
```

4. Jenkins 无权限操作 gitlab
```
stderr: Permission denied (publickey).
fatal: Could not read from remote repository.
```
解决：
1. 在 jenkins 后台，Jenkins -> 凭据 -> 系统 -> 全局凭据 中，配置 jenkins 这台机器的私钥，
从 ~/.ssh/id_rsa 中拷贝过来
2. 在 gitlab 中配置(创建) jenkins 用户，将公钥添加进来 ~/.ssh/id_rsa.pub
3. 这样 jenkins 机器才有权限读取代码

5. jenkins 机器没有操作部署应用机器权限
```
Failed to connect to the host via ssh: Warning: Permanently added 'xx.xx.xx.xx' (ECDSA) to the list of known hosts.\r\nPermission denied 
```
解决：
需要将 jenkins 机器的公钥，配置到应用机器的 .ssh/authorized_keys 文件下即可。

## 使用
* 配置JDK
* 配置Maven
* 添加 Git 私钥
进入 Jenkins -> Credentials -> System -> Global credentials 页面中添加凭据，配置 jenkins 私钥
* 在 gitlab 中创建 jenkins 用户，并将公钥添加进去

