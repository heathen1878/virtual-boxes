#!/bin/bash
set -euo pipefail

# Update and upgrade...
echo 'Updating the list of available packages and versions, upgrading installed packages, and installing essential packages'
apt update && apt upgrade -y -qq && apt install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    net-tools \
    nginx

# Install Azure Cli
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Clean up
rm -rf /var/lib/apt/lists/*

# Configure the firewall
echo "Setting up the firewall to allow 443..."
ufw allow 443/tcp
ufw allow 22/tcp

echo "Enabling the firewall..."
ufw --force enable
