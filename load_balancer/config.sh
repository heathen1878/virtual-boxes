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
