#!/bin/bash

config_file="/config/wg0.conf"

startup () {
  wg-quick up $config_file
}

shutdown () {
  wg-quick down $config_file
}

startup
trap shutdown SIGTERM SIGINT SIGQUIT
sleep infinity
