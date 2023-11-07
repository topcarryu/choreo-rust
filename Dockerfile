FROM alpine

WORKDIR /usr/src/app

COPY ./content .

RUN set -x \
    && apk add --no-cache ca-certificates bash tzdata jq \
    && chmod +x install.sh entrypoint.sh \
    && sh install.sh \
    && rm install.sh \
    && addgroup -g 10002 choreo && adduser -D -u 10014 -G choreo choreo

USER 10014

EXPOSE 3000

ENV PORT=3000

ENTRYPOINT [ "bash", "entrypoint.sh" ]
