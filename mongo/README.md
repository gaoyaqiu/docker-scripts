# mongodb

## 使用
```
// 编译
docker-compose up -d --build

// 进入容器
docker exec -it mongo bash

// 创建admin用户
mongo
use admin
db.createUser({user:"admin",pwd:"123456",roles:[{role:"userAdminAnyDatabase",db:"admin"}]})

// 验证是否创建成功 返回1：成功
db.auth("admin","123456")

// exit 退出，使用admin登录
mongo admin -u admin -p 123456
// 创建数据库
use test
// 创建普通用户并给用户赋予访问test库的权限
db.createUser({ user: 'test', pwd: '123456', roles: [ { role: "readWrite", db: "test" } ] })
```