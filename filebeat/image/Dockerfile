FROM debian:jessie

MAINTAINER gaoyaqiu <gyq30494613@gmail.com>

ENV FILEBEAT_VERSION=6.5.4 \
    FILEBEAT_SHA1=888ca30e17773372aff0e2b2802948a2a1537e294435ee46587f267fa9403428ca57c43aad5f055fea8493a8acea9c42a860a16ddea65fde45f43e4542102d91

RUN set -x && \
  apt-get update && \
  apt-get install -y wget && \
  wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz -O /opt/filebeat.tar.gz && \
  cd /opt && \
  echo "${FILEBEAT_SHA1}  filebeat.tar.gz" | sha512sum -c - && \
  tar xzvf filebeat.tar.gz && \
  cd filebeat-* && \
  cp filebeat /bin && \
  cd /opt && \
  rm -rf filebeat* && \
  apt-get purge -y wget && \
  apt-get autoremove -y && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

COPY image/docker-entrypoint.sh /docker-entrypoint.sh
COPY config/filebeat.yml /filebeat.yml

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [ "filebeat", "-e" ]