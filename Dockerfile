FROM node:20.7.0-bookworm

WORKDIR /usr/src/app

COPY ./content .

ENV PM2_HOME=/tmp

RUN set -x \
    && yarn global add pm2 \
    && curl -fsSLO --compressed "https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.16.1/shadowsocks-v1.16.1.x86_64-unknown-linux-gnu.tar.xz" \
    && curl -fsSLO --compressed "https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/v2ray-plugin-linux-amd64-v1.3.2.tar.gz" \
    && tar -xJf shadowsocks* \
    && tar -xzf v2ray* \
    && mv v2ray-plugin_linux_amd64 plugin \
    && chmod +x ss* plugin server.sh \
    && addgroup --gid 10014 choreo \
    && adduser --disabled-password  --no-create-home --uid 10014 --ingroup choreo choreouser \
    && usermod -aG sudo choreouser 

USER 10014

CMD [ "yarn", "start" ]
