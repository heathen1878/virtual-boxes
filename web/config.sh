#!/bin/bash
set -euxo pipefail

# Configure the firewall
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 22/tcp
ufw --force enable

# Update and install dependencies
apt-get update
apt-get install -y net-tools nginx nodejs npm

# copy nginx site configuration into place
cp /vagrant/web/nginx/sites-available/reactapp/reactapp /etc/nginx/sites-available/reactapp

# Create directories for web app
mkdir -p /var/www/reactapp/html

# Build node app
cd /vagrant/web
#npm run build

# copy web content