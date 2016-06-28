#
# Dockerfile for py-kms
#

FROM python:2-alpine
MAINTAINER Samuel X. S. Zeng <i@xlibc.me>

ADD ./py-kms /kms

EXPOSE 1688

CMD ["python", "/kms/server.py"]
