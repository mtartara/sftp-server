FROM centos:centos7
MAINTAINER ParTec

ENV USERNAME=timbube \
    HOME=/home/timbube

# SSH configuration
RUN yum install openssh-server -y
RUN ssh-keygen -A

# User configuration
RUN mkdir -p ${HOME}/upload &&\
    groupadd -g 1001 ${USERNAME} && \
    useradd -u 1001 -s /sbin/nologin -d ${HOME}/upload -m -g ${USERNAME} -p ${USERNAME} ${USERNAME}

# SSH user configuration
RUN mkdir -p ${HOME}/etc/ssh && \
    cp /etc/ssh/ssh_host* ${HOME}/etc/ssh

ADD sshd_config ${HOME}/etc/ssh/sshd_config

RUN mkdir -p ${HOME}/.ssh && \
    chmod 700 ${HOME}/.ssh

ADD authorized_keys ${HOME}/.ssh/authorized_keys

RUN chmod 600 ${HOME}/.ssh/authorized_keys && \
    chown -R ${USERNAME} ${HOME}

####
USER ${USERNAME}

WORKDIR ${HOME}/upload

EXPOSE 2222

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/home/timbube/etc/ssh/sshd_config"]
