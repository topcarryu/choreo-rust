#!/usr/bin/env bash

PASSWD=${PASSWD:-'abcdefg'}
WSPATH=${WSPATH:-'user'}
PORT=${PORT:-'3000'}

cp /usr/src/app/ss-conf.json /tmp/ss.json
sed -i "s|WSPATH|${WSPATH}|g;s|PASSWD|${PASSWD}|" /tmp/ss.json

cp /usr/src/app/nginx_ss.conf /tmp/nginx_ss.conf
sed -i "s|WSPATH|${WSPATH}|g;s|PORT|${PORT}|" /tmp/nginx_ss.conf

/usr/src/app/ssserver -c /tmp/ss.json &
nginx -c /tmp/nginx_ss.conf &