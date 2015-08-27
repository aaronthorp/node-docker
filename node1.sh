#/bin/bash

PRIVATE_IP=$(ifconfig eth1 | awk -F ' *|:' '/inet addr/{print $4}')

apt-get update
apt-get -y upgrade
apt-get -y install git curl

curl -sSL https://get.docker.com/ubuntu/ | sudo sh

docker build -t "app" app/
docker build -t "haproxy" haproxy/

$(docker run --rm progrium/consul cmd:run $PRIVATE_IP -d -p 8080:8500 --name consul)

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
