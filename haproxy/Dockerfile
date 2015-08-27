FROM ubuntu:14.04
RUN apt-get update -y && apt-get install -y curl wget supervisor build-essential
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /logs
RUN cd /usr/local/bin && wget https://github.com/hashicorp/consul-template/releases/download/v0.10.0/consul-template_0.10.0_linux_amd64.tar.gz && tar -xf consul-template_0.10.0_linux_amd64.tar.gz --strip-components 1 && rm consul-template_0.10.0_linux_amd64.tar.gz
RUN cd /opt && wget http://www.haproxy.org/download/1.5/src/haproxy-1.5.3.tar.gz
RUN cd /opt && tar xzf haproxy-1.5.3.tar.gz
RUN cd /opt/haproxy-1.5.3 && make TARGET=linux2628 && make install
ADD haproxy.cfg /opt/haproxy-1.5.3/haproxy.cfg
ADD haproxy.tmpl /opt/haproxy.tmpl
ADD supervisor.conf /etc/supervisor/conf.d/supervisor.conf

EXPOSE 80
CMD "/usr/bin/supervisord"
