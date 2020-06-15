FROM node:10.20.1-jessie

ENV HOME /home
ENV VENDORS ${HOME}/vendors
ARG GIT_URL=https://legend-oss-public.oss-cn-hangzhou.aliyuncs.com/tools/v1.9.2.tar.gz

WORKDIR ${HOME}

COPY docker-entrypoint.sh .
COPY config.json .

RUN chmod a+x docker-entrypoint.sh \
  && mkdir -p ${VENDORS} \
  && mkdir -p /home/install \
  && curl -SL ${GIT_URL} -o yapi.tar.gz \
  && tar zxvf yapi.tar.gz \
  && mv yapi-1.9.2/* ${VENDORS}/ \
  && cd ${VENDORS} \
  && npm install --production --registry https://registry.npm.taobao.org
EXPOSE 3000
ENTRYPOINT ["/home/docker-entrypoint.sh"]