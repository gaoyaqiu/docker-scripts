FROM python:3.6.5
LABEL maintainer="gyq30494613@gmail.com"

WORKDIR /var/www/data
ADD . /var/www/data/

ENV TZ=Asia/Shanghai
ENV LANG=C.UTF-8

COPY ./sources.list /etc/apt/sources.list

RUN apt-get update && \
  apt-get install -y --no-install-recommends cron vim tzdata && \
  pip install -i https://mirrors.aliyun.com/pypi/simple/ -U pip && \
  pip install -i https://mirrors.aliyun.com/pypi/simple/ --no-cache-dir -r requirement.txt && \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
  ln -s /usr/local/bin/python3.6 /usr/bin/python3.6 && \
  dpkg-reconfigure --frontend noninteractive tzdata && \
  echo 'export PYTHONUNBUFFERED=1' >> /etc/profile && \
  echo 'export LANG=C.UTF-8' >> /etc/profile && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get clean

ADD script/crontab/cron-jobs /etc/cron.d/cron-jobs

ADD docker-entrypoint.sh /opt/docker-entrypoint.sh
RUN chmod +x /opt/docker-entrypoint.sh

CMD ["/bin/sh", "/opt/docker-entrypoint.sh"]