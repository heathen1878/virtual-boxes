server {
        listen 80;
        server_name ${HOSTNAME};

        root /var/www/${WEB_FOLDER}/html;

        index index.html;

        location / {
                try_files $uri $uri/ =404;
        }

        location /env.js {
                add_header Cache-Control "no-store, no-cache, must-revalidate, proxy-validate, max-age=0";
        }
}