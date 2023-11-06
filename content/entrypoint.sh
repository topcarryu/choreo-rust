#!/usr/bin/env bash

PASSWD=${PASSWD:-'abcdefg'}
WSPATH=${WSPATH:-'user'}
PORT=${PORT:-'3000'}

sed -i "s#WSPATH#${WSPATH}#g;s#PASSWD#${PASSWD}#g" /usr/src/app/ss-config.json > /tmp/ss.json
sed -i "s#WSPATH#${WSPATH}#g;s#PORT#${PORT}#g" /usr/src/app/nginx_ss.conf > /tmp/nginx_ss.conf

rm -rf /usr/share/nginx/*
wget https://gitlab.com/Misaka-blog/xray-paas/-/raw/main/mikutap.zip -O /usr/share/nginx/mikutap.zip
unzip -o "/usr/share/nginx/mikutap.zip" -d /usr/share/nginx/html
rm -f /usr/share/nginx/mikutap.zip

ss-server -c /tmp/ss.json &
nginx -c /tmp/nginx_ss.conf &