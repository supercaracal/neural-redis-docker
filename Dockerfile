FROM redis:latest

RUN apt-get update \
  && apt-get install -y --no-install-recommends wget gcc make unzip libc6-dev ca-certificates \
  && rm -rf /var/lib/apt/lists/* \
  && wget -O neural-redis.zip  https://github.com/antirez/neural-redis/archive/master.zip \
  && mkdir -p /usr/lib/redis/modules \
  && unzip neural-redis.zip -d /usr/src \
  && rm neural-redis.zip \
  && make -C /usr/src/neural-redis-master generic \
  && mv /usr/src/neural-redis-master/neuralredis.so /usr/lib/redis/modules/ \
  && rm -r /usr/src/neural-redis-master \
  && apt-get purge -y --auto-remove wget gcc make unzip libc6-dev ca-certificates

CMD ["redis-server", \
     "--maxmemory",        "256mb", \
     "--maxmemory-policy", "allkeys-lru", \
     "--loadmodule",       "/usr/lib/redis/modules/neuralredis.so"]
