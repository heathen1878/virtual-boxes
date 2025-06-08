# Backends
# The names will need to be resolvable.
upstream ${BACKEND} {
    server ${BACKEND1};
    server ${BACKEND2};
}

# Need to workout how to pass https to http and https to https

server {
    listen 80;

    server_name ${FQDN};

    location / {
        proxy_pass http://${BACKEND};
    }
}