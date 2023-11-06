module.exports = {
    "apps": [
        {
            "name": "web",
            "script": "/usr/src/app/ssserver -c /tmp/ss.json"
        },
        {
            "name": "caddy",
            "script": "caddy run --config /usr/src/app/Caddyfile --adapter caddyfile"
        },
        {
            "name": 'argo',
            "script": "/usr/src/app/cloudflared --loglevel fatal tunnel --edge-ip-version auto --config /tmp/argo.yaml run"
        }
    ]
}