#/bin/bash

`docker run --rm progrium/consul cmd:run 0.0.0.0::128.199.99.237:0.0.0.0 -d`

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
