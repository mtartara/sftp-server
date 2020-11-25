FROM alpine:latest
MAINTAINER Matteo Tartara Par-Tec

ENV USERNAME=timbube \
    HOME=/home/timbube

RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && apk add openssh shadow@community

ADD sshd_config /etc/ssh/sshd_config

RUN ssh-keygen -A

RUN mkdir -p ${HOME} &&\
    groupadd -g 1001 ${USERNAME} && \
    useradd -u 1001 -s /sbin/nologin -d ${HOME} -m -g ${USERNAME} -p ${USERNAME} ${USERNAME} && \
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
#USER ${USERNAME}

EXPOSE 2222
CMD ["/usr/sbin/sshd", "-D", "-e"]
