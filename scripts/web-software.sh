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

# Clean up
rm -rf /var/lib/apt/lists/*