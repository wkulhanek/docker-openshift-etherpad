FROM centos:7
MAINTAINER Wolfgang Kulhanek <WolfgangKulhanek@gmail.com>

RUN yum -y update && \
    yum -y install epel-release && \
    yum -y install openssl npm node && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    mkdir /var/lib/etherpad

WORKDIR /var/lib/etherpad

COPY docker-entrypoint.sh ./
COPY fix-permissions.sh ./
COPY settings.json ./

# A few workarounds to run as non-root on OpenShift
RUN curl -L https://github.com/ether/etherpad-lite/tarball/1.6.1 | tar -xz --strip-components=1 && \
    mkdir .npm && \
    ./fix-permissions.sh .npm && \
    ./fix-permissions.sh /var/lib/etherpad

# Run as a random user. This happens on openshift by default so we
# might as well always run as a random user
USER 1001

# Listens on 9001 by default
EXPOSE 9001
ENTRYPOINT ["./docker-entrypoint.sh"]
