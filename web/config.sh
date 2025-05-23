#!/bin/bash
set -euxo pipefail

# Configure the firewall
ufw enable
ufw allow port 80/tcp
ufw allow port 443/tcp

# Update and install dependencies
apt-get update
apt-get install -y net-tools nginx nodejs

