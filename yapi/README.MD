## 使用说明
### 编译镜像及启动
```
docker-compose up -d --build
```

### 访问
http://x.x.x.x:3000

admin@admin.com
ymfe.org

## 问题
> 如果遇到连接mongo异常，需要手动初始化下用户
### 创建mongodb用户
```
// 连接容器db
docker exec -it mongo bash

// 进入mongo
mongo
use admin
// 创建admin用户
db.createUser({user: "admin",pwd: "123456",roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]})
db.auth("admin","123456")
exit
// 使用admin账户登录
mongo admin -u admin -p 123456
use yapi
db.yapi.insert( { test : "test" })
// 查看db
show dbs
// 创建yapi用户
db.createUser(
 {
   user: "yapi",
   pwd: "yapi",
   roles: [
      { role: "readWrite", db: "yapi" }
   ]
 }
)
db.auth("yapi","yapi")

```
> 用户初始化之后，重新启动  docker-compose up -d --build
