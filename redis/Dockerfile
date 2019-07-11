FROM redis:4-alpine

USER root

COPY redis.conf /usr/local/etc/redis/redis.conf

VOLUME /var/log/redis

CMD [ "redis-server", "/usr/local/etc/redis/redis.conf"  ]
