#!/bin/bash
set -euo pipefail

for site in "$@"
do
    echo "Creating $site"

    echo "Copying nginx.config into sites-available..."
    cp /vagrant/web/nginx_conf/http.tpl /etc/nginx/sites-available/$site

    # Use envsubst to transform the .tpl file...

    echo "Making directories to hold web app content..."
    mkdir -p /var/www/$web_folder/html

    echo "Copying content to directories created previously..."
    cp -r /vagrant/web/app/build/* /var/www/$web_folder/html

    echo "Enabling site..."
    ln -s /etc/nginx/sites-available/$site /etc/nginx/sites-enabled/$site

    echo "Testing configuration..."
    RESULT=$(nginx -t 2>&1)
    echo $RESULT

    echo "Reloading nginx..."
    nginx -s reload
done