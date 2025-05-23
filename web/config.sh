#!/bin/bash
set -euxo pipefail

# Configure the firewall
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 22/tcp
ufw --force enable

# Update and install dependencies
apt-get update
apt-get install -y net-tools nginx curl gnupg2s

# Get Node from Node Source PPA
curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
chmod +x nodesource_setup.sh
./nodesource_setup.sh
apt install npm

# copy nginx site configuration into place
cp /vagrant/web/nginx/sites-available/reactapp/reactapp /etc/nginx/sites-available/reactapp

# Create directories for web app
mkdir -p /var/www/reactapp/html

# Build node app
cd /vagrant/web

# Install node modules
npm install 

npm run build

# copy web content
cp build /var/www/reactapp/html

# Enable the site
ln -s /etc/nginx/sites-available/reactapp /etc/nginx/sites-enabled/reactapp

# Test
RESULT=$(nginx -t)
echo $RESULT

# reload config
nginx -s reload