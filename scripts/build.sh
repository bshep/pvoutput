#!/bin/bash

docker build --tag=pvoutput .
docker tag pvoutput bshep/pvoutput:latest
docker push bshep/pvoutput
