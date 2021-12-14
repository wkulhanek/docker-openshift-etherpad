#!/bin/bash
export VERSION=1.8.16
podman build . -t quay.io/gpte-devops-automation/etherpad:${VERSION}
podman tag quay.io/gpte-devops-automation/etherpad:${VERSION} quay.io/gpte-devops-automation/etherpad:latest
podman push quay.io/gpte-devops-automation/etherpad:${VERSION}
podman push quay.io/gpte-devops-automation/etherpad:latest
git tag ${VERSION}
git push origin ${VERSION}
