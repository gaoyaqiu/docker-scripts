FROM nginx:1.13-alpine

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk update && apk add --update-cache curl bash tzdata \
  && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && rm -rf /var/cache/apk/*

ADD . /etc/nginx/


ENV PORT 80
HEALTHCHECK CMD netstat -tuplen | grep -w $PORT || exit 1
