# syntax=docker/dockerfile:1

FROM docker.io/apache/spark:4.1.4-scala2.13-java17-python3-ubuntu

ARG ICEBERG_SPARK_URL=https://repo.maven.apache.org/maven2/org/apache/iceberg/iceberg-spark-runtime-4.1_2.13/1.12.0/iceberg-spark-runtime-4.1_2.13-1.12.0.jar
ARG ICEBERG_AWS_URL=https://repo.maven.apache.org/maven2/org/apache/iceberg/iceberg-aws-bundle/1.12.0/iceberg-aws-bundle-1.12.0.jar

USER root

RUN set -eu \
    && curl --fail --show-error --location --retry 3 -O --output-dir /opt/spark/jars/ \
        "${ICEBERG_SPARK_URL}" \
    && curl --fail --show-error --location --retry 3 -O --output-dir /opt/spark/jars/ \
        "${ICEBERG_AWS_URL}" \
    && chmod 0644 /opt/spark/jars/iceberg-*.jar

USER spark

RUN /opt/spark/bin/spark-submit --version
