FROM debian:bookworm

WORKDIR /usr/src/app

COPY ./content .

RUN set -x \
    && apt update -y \
    && apt install -y nginx curl \
    && curl -fsSLO --compressed "https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.17.0/shadowsocks-v1.17.0.x86_64-unknown-linux-gnu.tar.xz" \
    && curl -fsSLO --compressed "https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/v2ray-plugin-linux-amd64-v1.3.2.tar.gz" \
    && curl -fsSLO --compressed "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64" \
    && tar -xJf shadowsocks* \
    && tar -xzf v2ray* \
    && mv cloudflared-linux-amd64 cloudflared \
    && mv v2ray-plugin_linux_amd64 plugin \
    && chmod +x ss* plugin entrypoint.sh cloudflared \
    && addgroup --gid 10014 choreo \
    && adduser --disabled-password  --no-create-home --uid 10014 --ingroup choreo choreouser \
    && usermod -aG sudo choreouser 

USER 10014

EXPOSE 3000

ENV PORT=3000

ENTRYPOINT [ "bash", "entrypoint.sh" ]
