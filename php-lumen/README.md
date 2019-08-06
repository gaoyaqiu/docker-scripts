# php-lumen
php lumen docker 开发环境搭建

## nginx

## php
* 首次运行或者有改动的情况下，需要先编译镜像
```
cd php-lumen
docker-compose up -d --build
```
* 在本地有镜像的情况下，可以直接运行
```
docker-compose up -d
```