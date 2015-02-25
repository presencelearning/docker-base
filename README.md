# docker-base
A base container with logstash-forwarder installed. 

To use it, your dockerfile should start with something like:
FROM            ablerman/docker-base

**Note:
If you'd like to use logstash-forwarder, you'll need to provide some configuration. Start with /etc/logstash-forwarder/logstash-forwarder.conf
and insert the configuration for your application into the files block.