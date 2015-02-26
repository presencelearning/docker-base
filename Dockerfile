FROM            ubuntu:14.04
MAINTAINER      Sandy Lerman <sandy@presencelearning.com>


RUN apt-get update

RUN \
  apt-get install -y build-essential golang ruby-dev gcc wget supervisor \
  && gem install fpm

RUN \
  wget https://github.com/elasticsearch/logstash-forwarder/archive/v0.3.1.tar.gz -O /tmp/logstash-forwarder.tar.gz \
  && cd /tmp && tar xzf logstash-forwarder.tar.gz && cd logstash-forwarder-0.3.1/ && go build && make deb \
  && dpkg -i lumberjack_0.3.1_amd64.deb

RUN \
  apt-get remove -y build-essential golang ruby-dev gcc wget \
  && apt-get autoremove -y \
  && apt-get clean && rm -rf /var/lib/{apt,dpkg,cache,log,gems}/ \
  && rm -rf /tmp/*

COPY config/logstash-forwarder.conf /etc/logstash-forwarder/

RUN mkdir -p /var/log/supervisor
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]