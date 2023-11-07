FROM node:21-alpine

WORKDIR /home/choreouser

COPY /content/ .

RUN apk add --no-cache ca-certificates jq bash \
    && npm install \
    && sh install.sh \
    && rm install.sh \
    && chmod +x entrypoint.sh \
    && addgroup -g 10002 choreo && adduser -D -u 10001 -G choreo choreo

ENTRYPOINT [ "npm", "start" ]

USER 10001