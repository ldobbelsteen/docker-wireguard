#!/bin/bash

config_file="/config/wireguard.conf"

open () {
  wg-quick up $config_file
}

close () {
  wg-quick down $config_file
}

close
open

trap close SIGTERM SIGINT SIGQUIT

while true; do :; done
