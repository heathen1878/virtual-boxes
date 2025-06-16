#!/bin/bash
set -euo pipefail

for site in "$@"
do
    echo "Creating $site"

    TPLPATH="/vagrant/load_balancer/nginx_conf/lb-http.tpl"
    AVAILABLE_SITE="/etc/nginx/sites-available/$site"
    ENABLED_SITE="/etc/nginx/sites-enabled/$site"

    # Generate NGINX configuration
    envsubst '${BACKEND} ${BACKEND1} ${BACKEND2} ${FQDN} ${CERT_NAME}' < "$TPLPATH" > "$AVAILABLE_SITE"


done