# virtual-boxes
Uses Vagrant to spin up Virtual Machines in Virtual box

```shell
make help
```

## Builds an Ubuntu VM running NGINX as a Web Server

This builds an Ubuntu VM running NGINX with two websites accessible over port 80. 

```shell
make web-server
```

This builds an Ubuntu VM running NGINX with two websites accessible over port 443. This requires the `web/.env` file has been populated with the required information to pull certificates from Key Vault.

```shell
make web-server2
```

## Builds an Ubuntu VM running NGINX as a Load Balancer

```shell
make load-balancer
```

With two NGINX web servers behind it; the Web Servers could be Apache, or even IIS.

