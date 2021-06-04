# Use Red Hat Universal Base Image 8 - NodeJS 14 version
FROM registry.access.redhat.com/ubi8/nodejs-14:latest

ARG ETHERPAD_VERSION="1.8.13"

LABEL name="Etherpad Lite" \
      io.k8s.display-name="Etherpad Lite" \
      io.k8s.description="Provide an Etherpad on top of Red Hat OpenShift." \
      io.openshift.expose-services="9001" \
      io.openshift.tags="etherpad" \
      build-date="2021-06-04" \
      version=$ETHERPAD_VERSION \
      maintainer="Wolfgang Kulhanek <WolfgangKulhanek@gmail.com>" \
      release="1"

USER root
# RUN yum -y update && \
#     yum -y install openssl && \
#     yum clean all && \
#     rm -rf /var/cache/yum && \
#     mkdir -p /opt/etherpad
RUN yum -y update --nobest
RUN yum -y install openssl
RUN yum clean all
RUN rm -rf /var/cache/yum
RUN mkdir -p /opt/etherpad

# A few workarounds to run as non-root on OpenShift
RUN curl -L -o /tmp/etherpad.tar.gz https://github.com/ether/etherpad-lite/archive/$ETHERPAD_VERSION.tar.gz && \
    tar -xzf /tmp/etherpad.tar.gz --strip-components=1 -C /opt/etherpad && \
    rm /tmp/etherpad.tar.gz && \
    mkdir /opt/etherpad/.npm && \
    mkdir /.npm && \
    mkdir /.config && \
    chmod 777 /.npm

RUN mkdir -p /opt/etherpad/bin
COPY ./root/opt/etherpad/bin/fix-permissions.sh /opt/etherpad/bin
COPY ./root/opt/etherpad/container-entrypoint.sh /opt/etherpad/
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
