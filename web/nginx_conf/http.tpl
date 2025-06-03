server {
        listen 80;
        server_name ${HOSTNAME};

        root /var/www/${HOSTNAME}/html;

        index index.html;

        location / {
                try_files $uri $uri / =404;
        }
}