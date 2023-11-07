FROM alpine

ENV PORT=3000

WORKDIR /home/choreouser

COPY ./content .

RUN set -x \
    && apk add --no-cache ca-certificates bash jq bind-tools\
    && chmod +x install.sh entrypoint.sh \
    && sh install.sh \
    && rm install.sh \
    && addgroup -g 10002 choreo && adduser -D -u 10014 -G choreo choreo

EXPOSE 3000

ENTRYPOINT [ "bash", "entrypoint.sh" ]

USER 10014