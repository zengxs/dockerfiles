#
# Dockerfile for squid-cache
#

FROM alpine:latest
MAINTAINER Samuel X.S. Tseng <samuel.zxs@gmail.com>

ENV SQUID_PKGS squid squid-lang-zh

RUN set -xe \
    && apk update \
    && apk add $SQUID_PKGS \
    && rm -rf /var/cache/apk/*

EXPOSE 3128 3130

ENTRYPOINT ["/usr/sbin/squid", "-NYCd1"]
