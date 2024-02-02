FROM alpine

COPY files/* ./

RUN apk add --no-cache iproute2 vim netcat-openbsd caddy &&\
    chmod +x install.sh entrypoint.sh &&\
    sh install.sh &&\
    addgroup --gid 10001 choreo &&\
    adduser --disabled-password  --no-create-home --uid 10001 --ingroup choreo choreouser

ENTRYPOINT [ "sh", "-c", "./entrypoint.sh" ]

USER 10001