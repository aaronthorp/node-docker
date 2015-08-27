#/bin/bash
docker run -d \
  -p 8400:8400 \
  -p 8500:8500 \
  -p 8600:53/udp \
  -h node1 \
  --name "consul" \
  progrium/consul -server -bootstrap -join 128.199.99.237 -client 0.0.0.0

docker run -d \
  --name=registrator \
  --net=host \
  --volume=/var/run/docker.sock:/tmp/docker.sock \
  gliderlabs/registrator:latest \
  consul://localhost:8500

docker run -d -p 81:80 --name app5 app
docker run -d -p 82:80 --name app6 app
docker run -d -p 83:80 --name app7 app
docker run -d -p 84:80 --name app8 app
