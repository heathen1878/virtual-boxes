#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

# Static IP from Vagrant environment
STATIC_IP="${STATIC_IP}"

# Detect current default interface
DEFAULT_IFACE=$(ip route | awk '/^default/ {print $5}' | head -n 1)

# Ubuntu typically uses 'netplan' for network config
# Detect the bridged interface (usually the second one after NAT)
BRIDGED_IFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | tail -n 1)

echo "📡 Configuring static IP $STATIC_IP on interface $BRIDGED_IFACE"

# Configure netplan manually
cat <<EOF | sudo tee /etc/netplan/99-vagrant-bridged.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    $BRIDGED_IFACE:
      addresses:
        - $STATIC_IP/24
      nameservers:
        addresses: [8.8.8.8]
      routes:
        - to: default
          via: 192.168.188.1
EOF

# Set permissions for netplan config
sudo chmod 600 /etc/netplan/99-vagrant-bridged.yaml

# Apply network config
sudo netplan apply 2>&1 | grep -v 'Cannot call Open vSwitch' || true

# Only remove default route if it’s via the NAT interface (not the bridged one)
if [[ "$DEFAULT_IFACE" != "$BRIDGED_IFACE" && -n "$DEFAULT_IFACE" ]]; then
  echo "⚠️ Removing default route via $DEFAULT_IFACE"
  ip route del default dev "$DEFAULT_IFACE" || true
fi

# Ensure correct hostname
hostnamectl set-hostname "$(hostname)"
echo "127.0.0.1 $(hostname)" >> /etc/hosts

echo "✅ static IP and hostname configured: $STATIC_IP"