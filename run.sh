#/bin/bash
docker run -d \
  -p 8400:8400 \
  -p 8500:8500 \
  -p 8600:53/udp \
  -h node1 \
  --name "consul" \
  progrium/consul -server -bootstrap -client 0.0.0.0

docker run -d \
  --name=registrator \
  --net=host \
  --volume=/var/run/docker.sock:/tmp/docker.sock \
  gliderlabs/registrator:latest \
  consul://localhost:8500

docker run -d -p 81:80 --name app1 app
docker run -d -p 82:80 --name app2 app
docker run -d -p 83:80 --name app3 app
docker run -d -p 84:80 --name app4 app

docker run -d -p 80:80 --name haproxy --net host haproxy
