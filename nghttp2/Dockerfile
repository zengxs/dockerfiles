#
# Dockerfile for nghttp2
#

FROM alpine:latest
MAINTAINER Samuel X.S. Tseng <samuel.zxs@gmail.com>

RUN set -xe \
    && apk update \
    && apk add --no-cache  nghttp2 \
    && rm -rf /var/cache/apk/*

ENTRYPOINT ["/usr/bin/nghttpx"]
