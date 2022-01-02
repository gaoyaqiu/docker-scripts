# mongodb

## 使用
```
// 编译
docker-compose up -d --build
docker-compose --compatibility up -d --build

// 进入容器
docker exec -it mongo bash

// 创建admin用户
mongo
use admin
db.createUser({user:"admin",pwd:"654321",roles:[{role:"userAdminAnyDatabase",db:"admin"}]})

// 验证是否创建成功 返回1：成功
db.auth("admin","654321")

// exit 退出，使用admin登录
mongo admin -u admin -p 654321
// 创建数据库
use test
// 创建普通用户并给用户赋予访问test库的权限
db.createUser({ user: 'test', pwd: '123456', roles: [ { role: "readWrite", db: "test" } ] })
```