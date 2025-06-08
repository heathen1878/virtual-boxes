#!/bin/bash
set -euo pipefail

# Configure the firewall
echo "Setting up the firewall to allow access from Load Balancer..."
ufw allow from ${LOAD_BALANCER_IP} proto tcp to any port ${PORT}
ufw allow 22/tcp

echo "Enabling the firewall..."
ufw --force enable