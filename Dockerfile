FROM alpine

WORKDIR /home/choreouser

COPY files/* /home/choreouser/

ENV PM2_HOME=/tmp

RUN apk add --no-cache iproute2 vim netcat-openbsd &&\
    chmod +x install.sh &&\
    sh install.sh &&\
    addgroup --gid 10001 choreo &&\
    adduser --disabled-password  --no-create-home --uid 10001 --ingroup choreo choreouser

ENTRYPOINT [ "node", "server.js" ]

USER 10001