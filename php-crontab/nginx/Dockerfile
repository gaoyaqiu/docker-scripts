FROM nginx:1.13-alpine
LABEL maintainer="xxx"

ADD conf.d/* /etc/nginx/conf.d/
ADD nginx.conf /etc/nginx/nginx.conf

ENV PORT 80
HEALTHCHECK CMD netstat -tuplen | grep -w $PORT || exit 1

