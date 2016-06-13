#
# Dockerfile for costomize images of docker
#

FROM alpine:latest
MAINTAINER Samuel Tseng <samuel@tseng.pw>

ENV DEV_PKGS alpine-sdk bash

RUN set -xe \
    && apk update \
    && apk add $DEV_PKGS

COPY ./ustc.repositories /etc/apk/repositories

CMD ["/bin/bash"]