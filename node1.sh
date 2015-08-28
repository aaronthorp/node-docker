#/bin/bash

PRIVATE_IP=$(ifconfig eth1 | awk -F ' *|:' '/inet addr/{print $4}')
DOCKER_IP=$(ifconfig docker0 | awk -F ' *|:' '/inet addr/{print $4}')

apt-get update
apt-get -y upgrade
apt-get -y install git curl

curl -sSL https://get.docker.com/ubuntu/ | sudo sh

docker build -t "app" app/
docker build -t "haproxy" haproxy/

docker run --name consul -h $HOSTNAME \
	-p $PRIVATE_IP:8300:8300 \
  -p $PRIVATE_IP:8301:8301 \
  -p $PRIVATE_IP:8301:8301/udp \
  -p $PRIVATE_IP:8302:8302 \
  -p $PRIVATE_IP:8302:8302/udp \
  -p $PRIVATE_IP:8400:8400 \
  -p $PRIVATE_IP:8500:8500 \
  -p $DOCKER_IP:53:53 \
  -p $DOCKER_IP:53:53/udp \
  -d \
  -p 8080:8500 \
  --name consul	\
  progrium/consul -server -advertise $PRIVATE_IP -bootstrap

docker run \
  -v /var/run/docker.sock:/tmp/docker.sock \
  -h $HOSTNAME \
  -d \
  --name registrator \
  --dns $DOCKER_IP \
  gliderlabs/registrator consul://consul.service.consul:8500

docker run -d -p $PRIVATE_IP::80 --name app1 app
docker run -d -p $PRIVATE_IP::80 --name app2 app
docker run -d -p $PRIVATE_IP::80 --name app3 app
docker run -d -p $PRIVATE_IP::80 --name app4 app

docker run -d \
  -p 80:80 \
  --name haproxy \
  --dns $DOCKER_IP \
  haproxy
