#!/bin/bash
echo "Starting node$ID"

if [ ! -f "/home/provenance/data/priv_validator_state.json" ]; then
    echo "Initializing validator configuration for node$ID"

    for file in /home/provenance/seed/shared-*; do
        cp "$file" "/home/provenance/config/${file##*/shared-}" || exit $?
    done;

    for file in /home/provenance/seed/node$ID-*; do
        cp "$file" "/home/provenance/config/${file##*/node$ID-}" || exit $?
    done;

    cat > /home/provenance/data/priv_validator_state.json <<EOF
{
    "height": "0",
    "round": 0,
    "step": 0
}
EOF

    code=$?
    if [ $code != 0 ]; then
        exit $code
    fi
fi

provenanced --testnet --home /home/provenance start