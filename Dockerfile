FROM centos:latest
MAINTAINER feiin(http://github.com/feiin)

# install mono 
RUN rpm --import "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF" && \
    yum-config-manager --add-repo http://download.mono-project.com/repo/centos/ 

RUN yum -y install mono-complete openssh-server wget mkfontscale

ENV JEXUS_VERSION 5.8.1

# install jexus
RUN curl -O http://www.linuxdot.net/down/jexus-$JEXUS_VERSION.tar.gz && \
    tar -zxvf jexus-$JEXUS_VERSION.tar.gz && \
    cd jexus-$JEXUS_VERSION && \
    ./install 


RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N '' && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -C '' -N ''  && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -C '' -N ''

RUN mkdir /www
COPY packages/config /usr/jexus/siteconf

# install fonts
COPY packages/comicsansms.ttf /usr/share/fonts/
RUN mkfontscale && mkfontdir && fc-cache -fv    

# start 
COPY packages/start.sh /

CMD ["/bin/bash", "/start.sh"]
