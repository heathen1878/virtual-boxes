#!/bin/bash
set -euxo pipefail

# Get Node from Node Source PPA
echo "Grab Node PPA script and running it, ready to install nodejs..."
curl -fsSL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh
chmod +x nodesource_setup.sh
./nodesource_setup.sh
apt install nodejs