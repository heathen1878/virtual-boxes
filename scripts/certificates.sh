#!/bin/bash
set -euo pipefail

VAULT_NAME="${AZURE_VAULT_NAME}"
CERT_NAME_1="${AZURE_CERT_NAME_1}"
CERT_NAME_2="${AZURE_CERT_NAME_2}"
CLIENT_ID="${CLIENT_ID}"
CLIENT_SECRET="${CLIENT_SECRET}"
TENANT_ID="${TENANT_ID}"

echo "🔐 Logging in to Azure with SP"
az login --service-principal \
  --username "$CLIENT_ID" \
  --password "$CLIENT_SECRET" \
  --tenant "$TENANT_ID" > /dev/null

# Now fetch the cert and reload nginx as in the earlier script
CERT_DIR="/etc/nginx/certs"
mkdir -p "$CERT_DIR"

# CERT 1
PFX_PATH="$CERT_DIR/$CERT_NAME_1.pfx"
PEM_PATH="$CERT_DIR/$CERT_NAME_1.pem"
KEY_PATH="$CERT_DIR/$CERT_NAME_1.pem"

echo "📥 Downloading cert $CERT_NAME_1 from $VAULT_NAME"
az keyvault certificate download \
  --vault-name "$VAULT_NAME" \
  --name "$CERT_NAME_1" \
  --file "$PFX_PATH" \
  --encoding PEM

echo "🔧 Converting $CERT_NAME_1 to PEM"
openssl pkcs12 -in "$PFX_PATH" -out "$PEM_PATH" -clcerts -nokeys -nodes
openssl pkcs12 -in "$PFX_PATH" -out "$KEY_PATH" -nocerts -nodes
chmod 600 "$PEM_PATH" "$KEY_PATH"

# CERT 2
PFX_PATH="$CERT_DIR/$CERT_NAME_2.pfx"
PEM_PATH="$CERT_DIR/$CERT_NAME_2.pem"
KEY_PATH="$CERT_DIR/$CERT_NAME_2.pem"

echo "📥 Downloading cert $CERT_NAME_2 from $VAULT_NAME"
az keyvault certificate download \
  --vault-name "$VAULT_NAME" \
  --name "$CERT_NAME_2" \
  --file "$PFX_PATH" \
  --encoding PEM

echo "🔧 Converting $CERT_NAME_2 to PEM"
openssl pkcs12 -in "$PFX_PATH" -out "$PEM_PATH" -clcerts -nokeys -nodes
openssl pkcs12 -in "$PFX_PATH" -out "$KEY_PATH" -nocerts -nodes
chmod 600 "$PEM_PATH" "$KEY_PATH"

echo "✅ NGINX SSL certificate downloaded and ready for assignment."