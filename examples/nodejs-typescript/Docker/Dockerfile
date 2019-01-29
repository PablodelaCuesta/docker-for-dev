FROM node:8-alpine

RUN npm install -g typescript

VOLUME /app
WORKDIR /app

ENTRYPOINT [ "tsc" ]