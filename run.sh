#!/bin/bash

config_file="/config/wg0.conf"

open () {
  wg-quick up $config_file
}

close () {
  wg-quick down $config_file
}

close
open
trap close SIGTERM SIGINT SIGQUIT
sleep infinity
