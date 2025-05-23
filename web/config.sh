#!/bin/bash
set -euxo pipefail

# Configure the firewall
echo "Setting up the firewall to allow 80 and 443..."
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 22/tcp

echo "Enabling the firewall..."
ufw --force enable

# Update and install dependencies
echo "Installing dependencies..."
apt-get update
apt-get install -y net-tools nginx curl

# Get Node from Node Source PPA
echo "Grab Node PPA script and running it, ready to install nodejs..."
curl -fsSL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh
chmod +x nodesource_setup.sh
./nodesource_setup.sh
apt install nodejs

# copy nginx site configuration into place
echo "Copying nginx app config into sites-available..."
cp /vagrant/web/nginx/sites-available/reactapp/reactapp /etc/nginx/sites-available/reactapp

# Create directories for web app
echo "Making directories to hold web app content..."
mkdir -p /var/www/reactapp/html

# copy web content
echo "Copying content to directories created previously..."
cp -r /vagrant/web/public/* /var/www/reactapp/html

# Enable the site
echo "Enabling site..."
ln -s /etc/nginx/sites-available/reactapp /etc/nginx/sites-enabled/reactapp

# Test
echo "Testing configuration..."
RESULT=$(nginx -t 2>&1)
echo $RESULT

# reload config
echo "Reloading nginx..."
nginx -s reload