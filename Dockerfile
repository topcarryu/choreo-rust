FROM debian:latest

WORKDIR /usr/src/app

COPY ./content .

RUN set -x \
    && apt update -y \
    && apt install -y caddy curl xz-utils wget unzip jq \
    && chmod +x install.sh entrypoint.sh \
    && addgroup --gid 10014 choreo \
    && adduser --disabled-password  --no-create-home --uid 10014 --ingroup choreo choreouser \
    && usermod -aG sudo choreouser

USER 10014

EXPOSE 3000

ENV PORT=3000

ENTRYPOINT [ "bash", "entrypoint.sh" ]
