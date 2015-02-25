FROM            dockerfile/nginx:latest
MAINTAINER      Sandy Lerman <sandy@presencelearning.com>


RUN \
  apt-get update && apt-get install -y golang ruby-dev gcc supervisor \
  && gem install fpm \
  && wget https://github.com/elasticsearch/logstash-forwarder/archive/v0.3.1.tar.gz -O /tmp/logstash-forwarder.tar.gz \
  && cd /tmp && tar xzf logstash-forwarder.tar.gz && cd logstash-forwarder-0.3.1/ && go build && make deb \
  && dpkg -i lumberjack_0.3.1_amd64.deb \
  && apt-get remove -y golang ruby-dev gcc && apt-get autoremove -y \
  && apt-get clean && rm -rf /var/lib/{apt,dpkg,cache,log,gems}/ \
  && rm -rf /tmp/*

COPY config/logstash-forwarder.conf /etc/logstash-forwarder/


RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]