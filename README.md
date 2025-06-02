# virtual-boxes
Uses Vagrant to spin up Virtual Machines in Virtual box

```shell
make help
```

## Builds an Ubuntu VM running NGINX as a Web Server

```shell
make web-server
```

This builds an Ubuntu VM running NGINX; it also grabs certificates from a defined Key Vault - use `web/.env` - see `web/.example_env` for an example - and applies them to the two defined websites.

## Builds an Ubuntu VM running NGINX as a Load Balancer

```shell
make load-balancer
```

With two NGINX web servers behind it; the Web Servers could be Apache, or even IIS.

