#!/bin/bash
docker build . -t wkulhanek/etherpad:latest
docker tag wkulhanek/etherad:latest wkulhanek/etherpad:1.6.1
docker push wkulhanek/etherpad:latest
docker push wkulhanek/etherpad:1.6.1
