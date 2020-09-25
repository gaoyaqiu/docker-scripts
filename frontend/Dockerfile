# Dockerfile is used here for Jenkins, not for your local env
FROM nginx:1.13-alpine
LABEL maintainer="gaoyaqiu"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
# 设置时区
RUN apk update && apk add --update-cache curl bash tzdata \
  && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && rm -rf /var/cache/apk/*

COPY dist /usr/share/nginx/html
ENV PORT 80
HEALTHCHECK CMD netstat -tuplen | grep -w $PORT || exit 1
