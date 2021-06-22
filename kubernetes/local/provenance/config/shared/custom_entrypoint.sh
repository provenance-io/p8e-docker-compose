#!/bin/bash

if [ ! -f "/home/provenance/data/priv_validator_state.json" ]; then
    echo "Initializing /home/provenance/data/priv_validator_state.json"

    cat > /home/provenance/data/priv_validator_state.json <<EOF
{
    "height": "0",
    "round": 0,
    "step": 0
}
EOF
fi

provenanced --testnet --home /home/provenance start