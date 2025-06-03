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

web-server: ##   Build a NGINX web server
	@echo "🚀 Building web server..."
	@vagrant up web1
	@echo "web server built..."

rebuild-web-server: ## Rebuild Virtual Boxes
	@echo "🧹 Cleaning up..."
	@vagrant destroy -f web1
	@sleep 15
	@make web-server

ssh-web1: ##   SSH into Web1
	@echo "🔑 SSH into web1"
	@vagrant ssh web1

load-balancer: ##   Build a Load Balancer and backends
	@echo "🚀 Building load balancer and web backends..."
	@vagrant up lb1
	@vagrant up web2
	@vagrant up web3
	@echo "environment built..."

rebuild-load-balancer: ## rebuild Load Balancer and backends
	@echo "🧹 Cleaning up..."
	@vagrant destroy -f lb1
	@vagrant destroy -f web2
	@vagrant destroy -f web3
	@sleep 15
	@make load-balancer

ssh-lb1: ##           SSH into Web1
	@echo "🔑 SSH into load balancer 1"
	@vagrant ssh lb1

clean: ##             Clean up everything
	@echo "🧹 Cleaning up..."
	@vagrant destroy -f
	@echo "Clean up complete!"

build-node-app1: ##   Builds the node app
	@echo "📦 Building node app..."
	@npm --prefix web/app1 install
	@npm --prefix web/app1 run build
	@echo "🚀 Node app built..."

build-node-app2: ##   Builds the node app
	@echo "📦 Building node app..."
	@npm --prefix web/app2 install
	@npm --prefix web/app2 run build
	@echo "🚀 Node app built..."