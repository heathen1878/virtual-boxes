# Backends
# The names will need to be resolvable.
upstream ${BACKEND} {
    server ${BACKEND1};
    server ${BACKEND2};
}

server {
        listen 80;
        server_name ${FQDN};
        return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name ${FQDN};

    location / {
        proxy_pass http://${BACKEND};
    }
}