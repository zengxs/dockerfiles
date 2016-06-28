#
# Dockerfile for py-kms
#

FROM python:2-alpine
MAINTAINER Samuel X. S. Zeng <i@xlibc.me>

ENV KMS_DIR /kms

ADD ./py-kms $KMS_DIR

CMD ["stunnel", "$KMS_DIR/server.py"]