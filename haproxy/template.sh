#/bin/bash
consul-template \
  -consul consul.service.consul \
  -template "/opt/haproxy.tmpl:/opt/haproxy-1.5.3/haproxy.cfg:haproxy reload"
