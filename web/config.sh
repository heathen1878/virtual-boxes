#!/bin/bash
set -euxo pipefail

# Configure the firewall
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 22/tcp
ufw --force enable

# Update and install dependencies
apt-get update
apt-get install -y net-tools nginx nodejs

