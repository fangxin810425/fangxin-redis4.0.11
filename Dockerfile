FROM alpine:latest
RUN apk add --no-cache --virtual .build-deps curl gcc supervisor linux-headers make musl-dev tar \
    && mkdir /data \
    && mkdir /data/redis \
    && cd /data \
    && curl -sO http://download.redis.io/releases/redis-4.0.11.tar.gz  \
    && tar xf redis-4.0.11.tar.gz \ 
    && rm -fr redis-4.0.11.tar.gz \ 
    && rm -fr /var/cache/apk/* \ 
    && cd redis-4.0.11 \
    && make PREFIX=/usr/local/redis install \
    && rm -fr redis-4.0.11 \
    && touch /data/redis/redis.log
COPY ./supervisord.conf /etc/supervisord.conf
COPY ./startredis.sh /startredis.sh
EXPOSE 6379/tcp
RUN chmod +x /startredis.sh
ONBUILD RUN /usr/bin/supervisorctl reload
ENTRYPOINT ["/startredis.sh"]

