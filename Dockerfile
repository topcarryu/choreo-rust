FROM node:21-alpine

WORKDIR /home/choreouser

COPY /content/ .

RUN apk add --no-cache ca-certificates jq bash \
    && yarn install \
    && sh install.sh \
    && rm install.sh \
    && chmod +x entrypoint.sh \
    && mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale \
    && addgroup -g 10002 choreo && adduser -D -u 10001 -G choreo choreo

ENTRYPOINT [ "bash", "entrypoint.sh" ]

USER 10001