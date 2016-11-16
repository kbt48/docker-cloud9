FROM centos:7
MAINTAINER Hiroki Kubota <hiro.k.0805+github@gmail.com>

# Install base package
RUN \
yum install -y epel-release && \
yum update -y && \
yum groupinstall -y "Development tools" && \
yum install -y glibc-static python-devel which supervisor php php-devel php-mbstring && \
yum clean all

# Install node.js
RUN curl -sL https://rpm.nodesource.com/setup_4.x | bash - && yum install -y nodejs

# Setup supervisor
ADD conf/supervisord.conf /etc
ADD conf/httpd.conf /etc/httpd/conf

# Install cloud9
RUN mkdir /logs && git clone https://github.com/c9/core.git /cloud9
WORKDIR /cloud9
RUN scripts/install-sdk.sh && sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js
ADD install_codeintel.sh /tmp
RUN sh /tmp/install_codeintel.sh

WORKDIR /workspace
CMD "/usr/bin/supervisord -c /etc/supervisord.conf"
