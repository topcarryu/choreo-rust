FROM node:latest

WORKDIR /home/choreouser

COPY files/* /home/choreouser/
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /home/choreouser/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /home/choreouser/tailscale

ENV PM2_HOME=/tmp

RUN apt-get update &&\
    apt-get install -y iproute2 vim netcat-openbsd &&\
    npm install -r package.json &&\
    npm install -g pm2 &&\
    mkdir -p /home/choreouser/data/tailscale-state /tmp/tailscale &&\
    addgroup --gid 10001 choreo &&\
    adduser --disabled-password  --no-create-home --uid 10001 --ingroup choreo choreouser &&\
    usermod -aG sudo choreouser &&\
    chmod +x web.js entrypoint.sh tail.sh &&\
    npm install -r package.json

ENTRYPOINT [ "node", "server.js" ]

USER 10001