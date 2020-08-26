# Docker Wireguard
Dockerized Wireguard setup intended for personal VPN use. A Wireguard-ready kernel on the host is required (Linux version 5.6 and up or a patched one).

## Key generation
Wireguard tools are available in the image, so you can generate keys if you don't have them already using the following commands:
```
# Generate private key
docker run --rm -i ldobbelsteen/wireguard wg genkey > privatekey

# Derive public key from the private key
docker run --rm -i ldobbelsteen/wireguard wg genkey < privatekey > publickey
```

## Simple example
```
docker run \
  --detach \
  --restart always \
  --cap-add NET_ADMIN \
  --volume /dev/net/tun:/dev/net/tun \
  --volume /path/to/config:/etc/wireguard/wg0.conf \
  --publish 51820:51820/udp \
  ldobbelsteen/wireguard
```

## Parameters
* `--detach` - Run the container in the background and not in the current shell.
* `--restart always` - Restart the container if it crashes and allow it to restart after a machine reboot.
* `--cap-add NET_ADMIN` - Give container networking privileges.
* `--volume /dev/net/tun:/dev/net/tun` - Give container tun driver access.
* `--volume /path/to/config:/etc/wireguard/wg0.conf` - Standard Wireguard configuration file. You can specify multiple ones and with any name (not just `wg0`).
* `--publish 51820:51820/udp` - Open the port on the container. This is the default port for Wireguard, but any port can be chosen.
