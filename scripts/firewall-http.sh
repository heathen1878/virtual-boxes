#!/bin/bash
set -euo pipefail

# Configure the firewall
echo "Setting up the firewall to allow 80 and 443..."
ufw allow 80/tcp
ufw allow 22/tcp

echo "Enabling the firewall..."
ufw --force enable