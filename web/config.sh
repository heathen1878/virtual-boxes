#!/bin/bash
set -euxo pipefail

# Configure the firewall
ufw allow port 80/tcp
ufw allow port 443/tcp
ufw allow port 22/tcp
ufw --force enable

# Update and install dependencies
apt-get update
apt-get install -y net-tools nginx nodejs

