FROM ubuntu:15.04

ENV SQUID_VERSION=3.3.8 \
    SQUID_CACHE_DIR=/var/cache/squid \
    SQUID_LOG_DIR=/var/log/squid3 \
    SQUID_USER=proxy

RUN apt-get -y install logrotate ssl-cert software-properties-common
RUN apt-add-repository ppa:brianbloniarz/opendoor -y && \
    apt-get update && \
    apt-get -y install squid-langpack squid3

RUN mv /etc/squid3/squid.conf /etc/squid3/squid.conf.dist

COPY squid.conf /etc/squid3/squid.conf
COPY entrypoint.sh /sbin/entrypoint.sh
COPY SSL-cert.pem /etc/squid3/SSL-cert.pem
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3128/tcp
VOLUME ["/var/cache/squid"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
