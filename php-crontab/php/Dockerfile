FROM php:5.6-fpm-alpine
LABEL maintainer="xxx"

ENV TIMEZONE Asia/Shanghai
ENV PHP_MEMORY_LIMIT 512M
ENV MAX_UPLOAD 50M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST 100M

# 解决 Alpine 镜像安装软件速度慢的问题
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk --update add tzdata \
  libjpeg-turbo-dev \
  libpng-dev \
  freetype-dev \
  && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && echo "${TIMEZONE}" > /etc/timezone

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/freetype2 --with-png-dir=/usr --enable-gd-native-ttf --with-jpeg-dir=/usr \
  && docker-php-ext-install mysqli gd mysql opcache zip

RUN apk del tzdata curl \
  && rm -rf /var/cache/apk/*

RUN echo "" > /etc/crontabs/root \
  && echo "0 */5 * * * cd /var/www/html/test && php test.php > /dev/null 2>&1" >> /etc/crontabs/root

WORKDIR /var/www/html
ADD start.sh /opt/start.sh
RUN chmod +x /opt/start.sh
EXPOSE 9000
CMD ["/bin/sh", "/opt/start.sh"]

