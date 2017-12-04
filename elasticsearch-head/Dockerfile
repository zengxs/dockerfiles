# Docker image for elasticsearch-head
FROM node:alpine
MAINTAINER zengxs

COPY ./elasticsearch-head /app
WORKDIR /app

RUN npm install -g grunt

EXPOSE 9100

CMD grunt server
