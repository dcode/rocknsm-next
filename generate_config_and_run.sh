#!/bin/bash -eux -o pipefail

PACKER_PID=

function cleanup {
    if [ ! -z "${PACKER_PID}" ]; then
        kill ${PACKER_PID}
    fi
}

trap cleanup EXIT

ct -files-dir=config/files/ -platform=custom < config/ignition.yaml  | jq -c -f transpile/ignition_2.2_to_3.0.jq > http/config.ign

packer build -only=vmware-iso -var-file=vars.json packer.json > packer.out &
PACKER_PID=$!

# Wait until the console port is created
fswatch  -1  --include 'serial0'  -L  /tmp/

# Wait just a smidge longer
sleep 2

# /tmp/serial0 is defined in packer.json
socat unix-connect:/tmp/serial0 readline,raw,echo=0
