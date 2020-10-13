FROM jnspow0409/php7-v8js:latest

ENV TZ=Asia/Shanghai
ENV LANG=C.UTF-8

COPY ./sources.list /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    cron \
    tzdata \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && echo 'export LANG=C.UTF-8' >> /etc/profile \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/freetype2/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

WORKDIR /var/www/html

ADD crontab/cron-jobs /etc/cron.d/cron-jobs
COPY ./www.conf /usr/local/etc/php-fpm.d

ADD docker-entrypoint.sh /opt/docker-entrypoint.sh
RUN chmod +x /opt/docker-entrypoint.sh

CMD ["/bin/sh", "/opt/docker-entrypoint.sh"]


