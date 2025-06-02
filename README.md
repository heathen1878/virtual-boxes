# virtual-boxes
Uses Vagrant to spin up Virtual Machines in Virtual box

```shell
make help
```

## Build an Ubuntu VM running NGINX

```shell
make web-server
```

This builds an Ubuntu VM running NGINX; it also grabs certificates from a defined Key Vault - use `web/.env` - see `web/.example_env` for an example - and applies them to the two defined websites.
