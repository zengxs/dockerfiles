#
# Dockerfile for stunnel
#

FROM debian:jessie
MAINTAINER Samuel Tseng <samuel@tseng.pw>

ENV STUNNEL_VER 5.32
ENV STUNNEL_URL https://www.stunnel.org/downloads/stunnel-$STUNNEL_VER.tar.gz
ENV STUNNEL_SHA256 0ee64774d7a720f3ffd129b08557ee0882704c7f65b859c40e315a175b68a6fd
ENV STUNNEL_FILE stunnel-$STUNNEL_VER.tar.gz
ENV STUNNEL_TEMP stunnel-$STUNNEL_VER-build
ENV STUNNEL_CONF_DIR /etc/stunnel
ENV STUNNEL_DEPS openssl
ENV $BUILD_DEPS build-essential libssl-dev curl

RUN set -xe \
    && apt-get update \
    && apt-get install -y $STUNNEL_DEPS $BUILD_DEPS \
    && mkdir $STUNNEL_TEMP \
        && cd $STUNNEL_TEMP \
        && curl -sSL $STUNNEL_URL -o $STUNNEL_FILE \
        && echo "$STUNNEL_SHA256 $STUNNEL_FILE" | sha256sum -c \
        && tar -xf $STUNNEL_FILE --strip 1 \
        && ./configure \
        && make install \
        && cd .. \
        && rm -rf $STUNNEL_TEMP \
    && apt-get purge -y --auto-remove $BUILD_DEPS \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p $STUNNEL_CONF_DIR

ADD ./stunnel.conf $STUNNEL_CONF_DIR/stunnel.conf

ENV CFG_FILE $STUNNEL_CONF_DIR/stunnel.conf

EXPOSE 443

CMD ["stunnel", "$CFG_FILE"]
