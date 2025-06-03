#!/bin/bash
set -euxo pipefail

for item in "$@"
do
    echo "Creating site for $item"
done

# copy nginx site configuration into place
# echo "Copying nginx app config into sites-available..."
# cp /vagrant/web/site1/app /etc/nginx/sites-available/app

# # Create directories for web app
# echo "Making directories to hold web app content..."
# mkdir -p /var/www/app1/html
# mkdir -p /var/www/app2/html

# # copy web content
# echo "Copying content to directories created previously..."
# cp -r /vagrant/web/app/build/* /var/www/app1/html
# cp -r /vagrant/web/app/build/* /var/www/app2/html

# # Enable the site
# echo "Enabling site..."
# ln -s /etc/nginx/sites-available/app1 /etc/nginx/sites-enabled/app1
# ln -s /etc/nginx/sites-available/app2 /etc/nginx/sites-enabled/app2

# # Test
# echo "Testing configuration..."
# RESULT=$(nginx -t 2>&1)
# echo $RESULT

# # reload config
# echo "Reloading nginx..."
# nginx -s reload