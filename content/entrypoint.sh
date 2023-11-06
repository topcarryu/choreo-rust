#!/usr/bin/env bash

PASSWD=${PASSWD:-'abcdefg'}
WSPATH=${WSPATH:-'user'}
PORT=${PORT:-'3000'}

sed -i "s#WSPATH#${WSPATH}#g;s#PASSWD#${PASSWD}#g" ss-config.json
sed -i "s#WSPATH#${WSPATH}#g;s#PORT#${PORT}#g" nginx_ss.conf > /etc/nginx/conf.d/ss.conf

rm -rf /usr/share/nginx/*
wget https://gitlab.com/Misaka-blog/xray-paas/-/raw/main/mikutap.zip -O /usr/share/nginx/mikutap.zip
unzip -o "/usr/share/nginx/mikutap.zip" -d /usr/share/nginx/html
rm -f /usr/share/nginx/mikutap.zip

ss-server -c ss-config.json &
rm -rf /etc/nginx/sites-enabled/default
nginx -g 'daemon off;'