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
cp /vagrant/web/app1/app1 /etc/nginx/sites-available/app1
cp /vagrant/web/app2/app2 /etc/nginx/sites-available/app2

# Create directories for web app
echo "Making directories to hold web app content..."
mkdir -p /var/www/app1/html
mkdir -p /var/www/app2/html

# copy web content
echo "Copying content to directories created previously..."
cp -r /vagrant/web/app1/build/* /var/www/app1/html
cp -r /vagrant/web/app2/build/* /var/www/app2/html

# Enable the site
echo "Enabling site..."
ln -s /etc/nginx/sites-available/app1 /etc/nginx/sites-enabled/app1
ln -s /etc/nginx/sites-available/app2 /etc/nginx/sites-enabled/app2

# Test
echo "Testing configuration..."
RESULT=$(nginx -t 2>&1)
echo $RESULT

# reload config
echo "Reloading nginx..."
nginx -s reload