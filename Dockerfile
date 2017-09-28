FROM centos:7
MAINTAINER Wolfgang Kulhanek <WolfgangKulhanek@gmail.com>
ENV ETHERPAD_VERSION="1.6.1"

LABEL name="Etherpad Lite" \
      io.k8s.display-name="Etherpad Lite" \
      io.k8s.description="Provide an Etherpad on top of Red Hat OpenShift." \
      io.openshift.expose-services="9001" \
      io.openshift.tags="etherpad" \
      build-date="2017-09-28" \
      version=$ETHERPAD_VERSION \
      release="1"

RUN yum -y update && \
    yum -y install epel-release && \
    yum -y install openssl npm node && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    mkdir -p /opt/etherpad

#WORKDIR /var/lib/etherpad

COPY ./root /
# COPY docker-entrypoint.sh ./
# COPY fix-permissions.sh ./
# COPY settings.json ./

# A few workarounds to run as non-root on OpenShift
RUN curl -L -o /tmp/etherpad.tar  https://github.com/ether/etherpad-lite/tarball/$ETHERPAD_VERSION && \
    tar -xzf /tmp/etherpad.tar --strip-components=1 -C /opt/etherpad && \
    rm /tmp/etherpad.tar && \
    mkdir /opt/etherpad/.npm && \
    /opt/etherpad/bin/fix-permissions.sh /opt/etherpad && \
    mkdir /.npm && \
    chmod 777 /.npm

# Run as a random user. This happens on openshift by default so we
# might as well always run as a random user
USER 1001

# Listens on 9001 by default
EXPOSE 9001
WORKDIR /opt/etherpad
ENTRYPOINT ["/opt/etherpad/docker-entrypoint.sh"]
