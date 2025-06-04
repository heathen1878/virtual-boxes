#!/bin/bash
set -euo pipefail

for site in "$@"
do
    echo "Creating $site"

    TPLPATH="/vagrant/web/nginx_conf/https.tpl"
    AVAILABLE_SITE="/etc/nginx/sites-available/$site"
    ENABLED_SITE="/etc/nginx/sites-enabled/$site"

    # Generate NGINX configuration
    envsubst '${HOSTNAME} ${WEB_FOLDER} ${FQDN} ${CERT_NAME}' < "$TPLPATH" > "$AVAILABLE_SITE"
    
    echo "Making directories to hold web app content..."
    mkdir -p /var/www/$WEB_FOLDER/html

    echo "Copying content to directories created previously..."
    cp -r /vagrant/web/app/build/* /var/www/$WEB_FOLDER/html

    # Used to inject the underlying hostname
    echo "window.__RUNTIME_CONFIG__ = { HOSTNAME: '$(hostname)' };" > /var/www/$WEB_FOLDER/html/env.js

    echo "Enabling site..."
    ln -sf "$AVAILABLE_SITE" "$ENABLED_SITE"

    echo "Testing configuration..."
    RESULT=$(nginx -t 2>&1)
    echo $RESULT

    echo "Reloading nginx..."
    nginx -s reload
done