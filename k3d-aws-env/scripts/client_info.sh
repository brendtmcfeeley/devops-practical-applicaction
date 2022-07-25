#!/usr/bin/env bash

# obtain current client information such as:
# ip -> current client ip address (isp address)
# for use with terraform external data definitions
#
# example:
#
# ./client_info.sh
# {"ip":"123.456.789.123"}

set -e
CLIENT_IP=$(curl -s -4 https://ifconfig.me/)
echo "{\"ip\":\"$CLIENT_IP\"}"