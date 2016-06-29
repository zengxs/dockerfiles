#
# Dockerfile for gost
#

FROM alpine:latest
MAINTAINER Samuel X. S. Zeng <i@xlibc.me>

ENV GOST_VER  2.0-rc2
ENV GOST_OS   linux
ENV GOST_ARCH amd64

ENV GOST_URL https://github.com/ginuerzh/gost/releases/download/$GOST_VER/gost_$GOST_VER_$GOST_OS_$GOST_ARCH.tar.gz
ENV GOST_DIR gost_$GOST_VER_$GOST_OS_$GOST_ARCH

RUN set -xe \
    && apk add --update curl \
    && curl -L $GOST_URL | tar -xz \
    && mv $GOST_DIR/gost /bin/ \
    && rm -rf $GOST_DIR
    && apk del --purge curl \
    && rm -rf /var/cache/apk/*

ENTRYPOINT ["gost"]
