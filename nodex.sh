#/bin/bash

PRIVATE_IP=$(ifconfig eth1 | awk -F ' *|:' '/inet addr/{print $4}')
DOCKER_IP=172.17.42.1

JOIN_IP=node1.thnk.xyz

apt-get update
apt-get -y upgrade
apt-get -y install git curl

curl -sSL https://get.docker.com/ubuntu/ | sudo sh

docker build -t "app" app/

$(docker run --rm progrium/consul cmd:run $PRIVATE_IP::$JOIN_IP -d -p 8080:8500)

docker run \
  -v /var/run/docker.sock:/tmp/docker.sock \
  -h $HOSTNAME \
  -d \
  --name registrator \
  --dns $DOCKER_IP \
  gliderlabs/registrator consul://consul.service.consul:8500

docker run -d -P --name app5 app
docker run -d -P --name app6 app
docker run -d -P --name app7 app
docker run -d -P --name app8 app
