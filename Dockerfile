# Use Red Hat Universal Base Image 8 - NodeJS 12 version
FROM registry.access.redhat.com/ubi8/nodejs-12:latest

MAINTAINER Wolfgang Kulhanek <WolfgangKulhanek@gmail.com>
ARG ETHERPAD_VERSION="1.8.6"

LABEL name="Etherpad Lite" \
      io.k8s.display-name="Etherpad Lite" \
      io.k8s.description="Provide an Etherpad on top of Red Hat OpenShift." \
      io.openshift.expose-services="9001" \
      io.openshift.tags="etherpad" \
      build-date="2020-09-19" \
      version=$ETHERPAD_VERSION \
      release="1"

USER root
RUN yum -y update && \
    yum -y install openssl && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    mkdir -p /opt/etherpad

COPY ./root /

# A few workarounds to run as non-root on OpenShift
RUN curl -L -o /tmp/etherpad.tar  https://github.com/ether/etherpad-lite/tarball/$ETHERPAD_VERSION && \
    tar -xzf /tmp/etherpad.tar --strip-components=1 -C /opt/etherpad && \
    rm /tmp/etherpad.tar && \
    mkdir /opt/etherpad/.npm && \
    mkdir /.npm && \
    mkdir /.config && \
    chmod 777 /.npm

WORKDIR /opt/etherpad

# Install a few default plugins:
RUN npm install ep_adminpads2 \
                ep_font_family \
                ep_font_size \
                ep_headings2 \
                ep_font_color \
                ep_aa_file_menu_toolbar \
                ep_copy_paste_select_all

# Copy Red Hat Background into the Image
COPY ./fond_redhat.jpg /opt/etherpad/src/static/skins/colibris/images/fond.jpg

# Fix permissions to run on OpenShift
RUN /opt/etherpad/bin/fix-permissions.sh /opt/etherpad && \
    /opt/etherpad/bin/fix-permissions.sh /.npm && \
    /opt/etherpad/bin/fix-permissions.sh /opt/app-root/src/.npm && \   
    /opt/etherpad/bin/fix-permissions.sh /.config && \
    /opt/etherpad/bin/fix-permissions.sh /opt/app-root/src/.config

# Run as a random user. This happens on openshift by default so we
# might as well always run as a random user
USER 1001

# Listens on 9001 by default
EXPOSE 9001
ENTRYPOINT ["/opt/etherpad/container-entrypoint.sh"]
