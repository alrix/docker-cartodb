# Installs standalone redis server for cartodb

FROM ubuntu:xenial

RUN apt-get update \
 && apt-get -y install software-properties-common \
 && apt-get -y install locales \
 && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8 \
 && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

ADD profile /root/.profile

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV RAILS_ENV production

# Install Redis
RUN add-apt-repository -y ppa:cartodb/redis-next \
 && apt-get update \
 && apt-get -y install redis \
 && rm -rf /var/lib/apt/lists/*
ADD redis.conf /etc/redis/redis.conf

EXPOSE 6379

VOLUME  ["/var/lib/redis", "/var/log/redis"]

CMD ["/usr/bin/redis-server", "/etc/redis/redis.conf"]
