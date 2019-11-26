FROM xxxx/oracle-java:8_server-jre_unlimited
LABEL maintainer="gyq30494613@gmail.com"

# 解决 Alpine 镜像安装软件速度慢的问题
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
# 安装字体工具及设置时区为京八区
RUN apk update && apk add --update-cache curl bash tzdata \
  && cp -r -f /usr/share/zoneinfo/Hongkong /etc/localtime \
  && rm -rf /var/cache/apk/*

ADD target/ci-test.jar /app.jar

ENV PORT 8088
HEALTHCHECK --interval=120s --timeout=300s CMD curl http://localhost:$PORT/actuator/health || exit 1
ENTRYPOINT java ${JAVA_OPTS} -Duser.timezone=GMT+08 -Djava.security.egd=file:/dev/./urandom -jar /app.jar