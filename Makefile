# Variables
VAGRANT_CONFIG_DIR=shared
BRIDGE_IFACE ?= enp1s0f0
export BRIDGE_IFACE

include web/.env
export

# Show help with descriptions
help:
	@echo ""
	@echo "📦 Available make targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?##' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'
	@echo ""

#########################################
http-web-server: ##   Build a NGINX web servers
	@make build-node-app
	@echo "🚀 Building web server..."
	@vagrant up web41
	@vagrant reload web41
	@echo "web server built..."

rebuild-http-web-server: ## Rebuild Virtual Boxes
	@echo "🧹 Cleaning up..."
	@vagrant destroy -f web41
	@sleep 15
	@make http-web-server

ssh-web1: ##   SSH into Web1
	@echo "🔑 SSH into web41"
	@vagrant ssh web41
#########################################

# Web Servers with TLS
#########################################
https-web-server: ##   Build a NGINX web server
	@make build-node-app
	@echo "🚀 Building web server..."
	@vagrant up web45
	@vagrant reload web45
	@echo "web server built..."

rebuild-https-web-server: ## Rebuild Virtual Boxes
	@echo "🧹 Cleaning up..."
	@vagrant destroy -f web45
	@sleep 15
	@make https-web-server

ssh-web2: ##   SSH into Web45
	@echo "🔑 SSH into web45"
	@vagrant ssh web45
#########################################

# Load Balancer with backends
#########################################
load-balancer-tls-offload: ##   Build a Load Balancer and backends
	@make build-node-app
	@echo "🚀 Building load balancer and web backends..."
	@vagrant up lb50
	@vagrant up web41
	@vagrant up web42
	@echo "environment built..."

rebuild-load-balancer: ## rebuild Load Balancer and backends
	@echo "🧹 Cleaning up..."
	@vagrant destroy -f lb50
	@vagrant destroy -f web41
	@vagrant destroy -f web42
	@sleep 15
	@make load-balancer

ssh-lb50: ##           SSH into Web1
	@echo "🔑 SSH into load balancer 50"
	@vagrant ssh lb50
#########################################

# Builds the Node App
#########################################
build-node-app: ##   Builds the node app
	@echo "📦 Building node app..."
	@npm --prefix web/app install
	@npm --prefix web/app run build
	@echo "🚀 Node app built..."
#########################################

# Clean up
#########################################
clean: ##             Clean up everything
	@echo "🧹 Cleaning up..."
	@vagrant destroy -f
	@echo "Clean up complete!"
#########################################