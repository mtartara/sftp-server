FROM alpine:latest
MAINTAINER Matteo Tartara Par-Tec

ENV USERNAME=timbube \
    HOME=/home/timbube

RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && apk add openssh shadow@community
ADD sshd_config /etc/ssh/sshd_config

RUN ssh-keygen -A

RUN mkdir -p ${HOME} &&\
    addgroup -S sftp &&\
    adduser -u 1001 -S -D -h ${HOME} ${USERNAME} sftp &&\
    chgrp -R 0 ${HOME} && chmod -R g=u ${HOME}


RUN mkdir -p ${HOME}/.ssh && \
    chmod 700 ${HOME}/.ssh && \
    chown ${USERNAME} ${HOME}/.ssh && \
    mkdir ${HOME}/upload && \
    chown ${USERNAME} ${HOME}/upload && \
    chown -R ${USERNAME} /etc/ssh/

WORKDIR ${HOME}/
USER ${USERNAME}

EXPOSE 2222
CMD ["/usr/sbin/sshd", "-D", "-e"]
