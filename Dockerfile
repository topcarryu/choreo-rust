FROM node:21-alpine

WORKDIR /home/choreouser

RUN apk add --no-cache ca-certificates \
    && yarn global add @3kmfi6hp/nodejs-proxy \
    && addgroup -g 10002 choreo && adduser -D -u 10001 -G choreo choreo

ENTRYPOINT [ "nodejs-proxy" ]

USER 10001