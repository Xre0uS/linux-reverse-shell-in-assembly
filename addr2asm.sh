#!/bin/bash

IP=$1
PORT=$2

IP=$(printf '%02x' $(echo $IP | tr '.' ' '))
IP=$(echo $IP | sed -r 's/(..) ?(..) ?(..) ?(..)/\4\3\2\1/')

PORT=$(printf '%04x\n' $PORT)
PORT=$(echo $PORT | sed -r 's/(..)(..)/\2\1/')

echo "0x${IP}"
echo "0x${PORT}"
