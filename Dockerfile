FROM ubuntu:18.04

# install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends supervisor postfix opendkim rsyslog && \
    rm -rf /var/lib/apt/lists/* 

# mail server will be listening on this port
EXPOSE 25

# add configuration files
ADD ./config/supervisord/supervisord.conf   /etc/supervisor/supervisord.conf
ADD ./config/rsyslog/rsyslog.conf           /etc/rsyslog.conf
ADD ./config/postfix/main.cf                /etc/postfix/main.cf
ADD ./config/postfix/header_checks          /etc/postfix/header_checks
ADD ./config/opendkim/opendkim.conf         /etc/opendkim.conf
ADD ./config/opendkim/opendkim              /etc/default/opendkim
ADD ./config/opendkim/TrustedHosts          /etc/opendkim/TrustedHosts
ADD ./config/opendkim/SigningTable          /etc/opendkim/SigningTable
ADD ./config/opendkim/KeyTable              /etc/opendkim/KeyTable

# configure the entrypoint
ADD ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
