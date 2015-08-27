#/bin/bash
docker run -d -p 81:80 app
docker run -d -p 82:80 app
docker run -d -p 83:80 app
docker run -d -p 84:80 app
docker run -d -p 80:80 haproxy
