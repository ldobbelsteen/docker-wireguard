#!/bin/bash

configs=$(find /etc/wireguard -type f)

shutdown () {
  for config in $configs; do
    wg-quick down $config
  done
}

startup () {
  for config in $configs; do
    wg-quick up $config
  done
}

startup
trap shutdown SIGTERM SIGINT SIGQUIT
sleep infinity