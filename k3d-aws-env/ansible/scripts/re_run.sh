#!/usr/bin/env bash

set -e

WAIT_MAX=$1
COMMAND=$2
WAIT=0

echo "Command to run: $COMMAND"
echo "Max Wait Time: $WAIT_MAX"

# retry command until we reach just over our max wait time
until [ $WAIT -gt $WAIT_MAX ] || eval $COMMAND; do
    sleep $(( WAIT++ ))
done

echo "Actual Wait Time: $WAIT"

# verify max wait time is within the max
[ $WAIT -le $WAIT_MAX ]