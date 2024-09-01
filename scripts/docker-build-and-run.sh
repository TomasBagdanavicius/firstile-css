#!/usr/bin/env bash

docker build -t firstile .
docker run -p 8082:8082 -d firstile
echo "http://localhost:8082/"
echo "http://localhost:8082/demo/slides.html"