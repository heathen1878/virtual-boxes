#!/bin/bash
set -euo pipefail

# Update and upgrade...
echo 'Updating the list of available packages and versions, upgrading installed packages, and installing essential packages'
apt update && apt upgrade -y -qq && apt install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl

# Install Azure Cli
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Clean up
rm -rf /var/lib/apt/lists/*