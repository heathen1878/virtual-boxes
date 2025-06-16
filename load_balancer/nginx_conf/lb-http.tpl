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

    ssl_certificate /etc/nginx/certs/${CERT_NAME}.pem;
    ssl_certificate_key /etc/nginx/certs/${CERT_NAME}-key.pem;
    ssl_protocols TLSv1.2 TLSv1.3;

    location / {
        proxy_pass http://${BACKEND};
    }
}