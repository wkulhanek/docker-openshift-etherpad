#!/bin/bash
export VERSION=1.7.5
docker build . -t quay.io/wkulhanek/etherpad:${VERSION}
docker tag quay.io/wkulhanek/etherpad:${VERSION} quay.io/wkulhanek/etherpad:latest
docker push quay.io/wkulhanek/etherpad:${VERSION}
docker push quay.io/wkulhanek/etherpad:latest
#git tag ${VERSION}
#git push origin ${VERSION}
