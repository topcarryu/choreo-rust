FROM node:16-bullseye

WORKDIR /usr/src/app

COPY ./content .

ENV PM2_HOME=/tmp

RUN set -x \
    && yarn install \
    && yarn global add pm2 \
    && wget -O - https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.15.4/shadowsocks-v1.15.4.x86_64-unknown-linux-gnu.tar.xz | tar -xJf shadowsocks*  \
    && wget -O - https://github.com/teddysun/xray-plugin/releases/download/v1.7.5/xray-plugin-linux-amd64-v1.7.5.tar.gz | tar -xzf xray* \
    && mv xray-plugin_linux_amd64 plugin \
    && chmod +x ss* plugin entrypoint.sh \
    && addgroup --gid 10014 choreo \
    && adduser --disabled-password  --no-create-home --uid 10014 --ingroup choreo choreouser \
    && usermod -aG sudo choreouser 

USER 10014

CMD [ "yarn", "start" ]
