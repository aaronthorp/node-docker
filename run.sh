#/bin/bash
docker run -d -p 81:80 --name app1 app
docker run -d -p 82:80 --name app2 app
docker run -d -p 83:80 --name app3 app
docker run -d -p 84:80 --name app4 app
docker run -d -p 80:80 --name haproxy haproxy
