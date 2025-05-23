# Variables
VAGRANT_CONFIG_DIR=shared
BRIDGE_IFACE ?= enp1s0f0
export BRIDGE_IFACE

# Show help with descriptions
help:
	@echo ""
	@echo "📦 Available make targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?##' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'
	@echo ""

build: ## Build Virtual Boxes
	@echo "🚀 Building virtual boxes..."
	@vagrant up
	@echo "Virtual boxes built..."

ssh-web01 ## SSH into Web01
	@echo "🔑 SSH into web01"
	@vagrant ssh web01