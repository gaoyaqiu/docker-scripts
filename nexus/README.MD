# nexus
挂载的nexus-data目录，需要给个 777 权限
```
chmod 777 nexus-data
```
## 启动
```
docker-compose up -d
```

## 访问
http://[IP]:8877/

打开之后，使用 admin 账号，登录下看看提示如下：
```
Your admin user password is located in
/nexus-data/admin.password on the server.
```
到 /nexus-data/admin.password 目录中查看 admin 密码登录即可。
