server {
        listen 80;
        server_name ${HOSTNAME};
        return 301 https://${FQDN}$request_uri;
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
        
        root /var/www/${WEB_FOLDER}/html;

        index index.html;

        location / {
               try_files $uri $uri/ =404;
        }
}