#/bin/bash

PRIVATE_IP=$(ifconfig eth1 | awk -F ' *|:' '/inet addr/{print $4}')

apt-get update
apt-get -y upgrade
apt-get -y install git curl

curl -sSL https://get.docker.com/ubuntu/ | sudo sh

docker build -t "app" app/
docker build -t "haproxy" haproxy/

docker run --name consul -h $HOSTNAME \
	-p 10.176.135.100:8300:8300 \
  -p 10.176.135.100:8301:8301 \
  -p 10.176.135.100:8301:8301/udp \
  -p 10.176.135.100:8302:8302 \
  -p 10.176.135.100:8302:8302/udp \
  -p 10.176.135.100:8400:8400 \
  -p 10.176.135.100:8500:8500 \
  -p 172.17.42.1:53:53 \
  -p 172.17.42.1:53:53/udp \
  -d \
  -p 8080:8500 \
  --name consul	\
  progrium/consul -server -advertise 10.176.135.100 -bootstrap

docker run \
  -v /var/run/docker.sock:/tmp/docker.sock \
  -h $HOSTNAME \
  -d \
  --name registrator \
  --dns 172.17.42.1 \
  progrium/registrator consul://consul.service.consul:8500

docker run -d -P --name app1 app
docker run -d -P --name app2 app
docker run -d -P --name app3 app
docker run -d -P --name app4 app

docker run -d \
  -p 80:80 \
  --name haproxy \
  --dns 172.17.42.1 \
  haproxy

  docker run -it --rm \
    -p 80:80 \
    --name haproxy \
    haproxy bash
