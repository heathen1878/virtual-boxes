#!/bin/bash
set -euo pipefail

VAULT_NAME="${AZURE_VAULT_NAME}"
CLIENT_ID="${CLIENT_ID}"
CLIENT_SECRET="${CLIENT_SECRET}"
TENANT_ID="${TENANT_ID}"

echo "🔐 Logging in to Azure with SP"
  az login --service-principal \
    --username "$CLIENT_ID" \
    --password "$CLIENT_SECRET" \
    --tenant "$TENANT_ID" > /dev/null

for cert in "$@"
do 
  echo "Installing $cert"

  SSL_DIR="/etc/ssl/certs"
  chmod 755 $SSL_DIR

  CERT_DIR="/etc/nginx/certs"
  mkdir -p "$CERT_DIR"

  # Path to save the certificate to
  PFX_PATH="$CERT_DIR/$cert.pfx"
  PEM_PATH="$CERT_DIR/$cert.pem"
  KEY_PATH="$CERT_DIR/$cert-key.pem"

  echo "📥 Downloading cert $cert from $VAULT_NAME"
  az keyvault secret download \
    --vault-name "$VAULT_NAME" \
    --name "$cert" \
    --file "$PFX_PATH" \
    --encoding base64  

  echo "🔧 Converting $cert to PEM"
  openssl pkcs12 -in "$PFX_PATH" -out "$PEM_PATH" -clcerts -nokeys -nodes -password pass:
  openssl pkcs12 -in "$PFX_PATH" -out "$KEY_PATH" -nocerts -nodes -password pass:

  # Set ownership and permissions for Ubuntu's NGINX user
  chown www-data:www-data "$PEM_PATH" "$KEY_PATH"
  chmod 600 "$PEM_PATH" "$KEY_PATH"

  # Copy into SSL directory
  cp $PEM_PATH $SSL_DIR
  cp $KEY_PATH $SSL_DIR

  # Clean up pfx and pem files
  rm -f $CERT_DIR/*

  echo "✅ NGINX SSL certificate downloaded and ready for assignment."
done