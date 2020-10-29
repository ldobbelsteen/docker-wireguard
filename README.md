# Docker Wireguard
Dockerized Wireguard setup intended for personal VPN use. A Wireguard-ready kernel on the host is required (Linux version 5.6 and up or a patched one).

## Building
There is a Dockerfile present in this repo to build an image. This can be done using the following command.
```
docker build --tag wireguard https://github.com/ldobbelsteen/docker-wireguard.git
```

## Key generation
Wireguard tools are available in the image, so you can generate keys if you don't have them already using the following commands.
```
# Generate private key
docker run --rm wireguard wg genkey > private_key

# Derive public key from the private key
docker run --rm wireguard wg pubkey < private_key > public_key
```

## Usage
The image can be run through docker-compose or directly. An example command can be found below.
```
docker run \
  --detach \
  --restart always \
  --cap-add NET_ADMIN \
  --volume /dev/net/tun:/dev/net/tun \
  --volume /path/to/config:/config/wireguard.conf \
  --publish 51820:51820/udp \
  wireguard
```

### Parameters
* `--detach` - Run the container in the background and not in the current shell.
* `--restart always` - Restart the container if it crashes and allow it to restart after a machine reboot.
* `--cap-add NET_ADMIN` - Give container networking privileges.
* `--volume /dev/net/tun:/dev/net/tun` - Give container tun driver access.
* `--volume /path/to/config:/config/wg0.conf` - Standard Wireguard configuration file. Only a single config file is supported.
* `--publish 51820:51820/udp` - Open the port on the container. You should set this to be the same port as in the config file.

## Configuration
An example for the server's configuration can be found below.
```
[Interface]
PrivateKey = <server-private-key>
Address = 10.10.10.1/24
ListenPort = 51820
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; iptables -A FORWARD -o %i -j ACCEPT
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; iptables -D FORWARD -o %i -j ACCEPT

[Peer]
AllowedIPs = 10.10.10.2/32
PublicKey = <client-public-key>
```

An example for a client's configuration can be found below.
```
[Interface]
PrivateKey = <client-private-key>
Address = 10.10.10.2/24
DNS = <dns-server-of-choice>

[Peer]
PublicKey = <server-public-key>
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = <server-hostname-or-ip>:51820
```
