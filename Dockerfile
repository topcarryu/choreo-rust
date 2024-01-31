FROM node:latest

WORKDIR /home/choreouser

COPY files/* /home/choreouser/

ENV PM2_HOME=/tmp

RUN apt-get update &&\
    apt-get install -y iproute2 vim netcat-openbsd &&\
    npm install -r package.json &&\
    npm install -g pm2 &&\
    addgroup --gid 10001 choreo &&\
    adduser --disabled-password  --no-create-home --uid 10001 --ingroup choreo choreouser &&\
    usermod -aG sudo choreouser &&\
    chmod +x web.js entrypoint.sh &&\
    npm install -r package.json

COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /home/choreouser/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /home/choreouser/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

ENTRYPOINT [ "node", "server.js" ]

USER 10001