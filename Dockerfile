FROM alpine:latest
MAINTAINER Matteo Tartara Par-Tec

ENV USERNAME=timbube \
    HOME=/home/timbube

RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && apk add openssh shadow@community

ADD sshd_config /etc/ssh/sshd_config

RUN ssh-keygen -A

RUN mkdir -p ${HOME} &&\
    addgroup --gid 1001 -S ${USERNAME} && \
    adduser -u 1001 -S -D -h ${HOME} ${USERNAME} ${USERNAME} -p ${USERNAME} && \
    chown root:root ${HOME}

RUN mkdir -p ${HOME}/.ssh && \
    chmod 700 ${HOME}/.ssh && \
    mkdir ${HOME}/upload && \
    chown ${USERNAME} ${HOME}/upload && \
    chown -R ${USERNAME} /etc/ssh/

ADD authorized_keys ${HOME}/.ssh/authorized_keys

RUN chown -R ${USERNAME} ${HOME}/.ssh && \
    chmod 600 ${HOME}/.ssh/authorized_keys

WORKDIR ${HOME}/

EXPOSE 2222
CMD ["/usr/sbin/sshd", "-D", "-e"]
