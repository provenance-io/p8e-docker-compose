#!/bin/bash
set -e

PROVENANCE_PATH=provenance

cd $PROVENANCE_PATH
make build
make localnet-start
MNEMONIC="fame shuffle honey general ten virtual cloth stock exchange liar muffin permit behind matter dumb genuine purchase fox used odor decline truth label load"
./build/provenanced -t keys add p8e \
	--home build/node0 \
	--keyring-backend test \
	--testnet \
	--recover \
	--hd-path "44'/1'/0'/0/0" \
	--output json <<< $MNEMONIC
# allow provenance network enough time to fully boot and configure
sleep 10
./build/provenanced tx bank send \
    $(./build/provenanced keys show -a node0 --home build/node0 --keyring-backend test --testnet) \
    $(./build/provenanced keys show -a p8e --home build/node0 --keyring-backend test --testnet) \
    10000000000000000nhash \
    --from node0 \
    --keyring-backend test \
    --home build/node0 \
    --chain-id chain-local \
    --gas-prices 1905nhash \
    --gas 100000 \
    --broadcast-mode block \
    --yes \
    --testnet

make localnet-stop

cd ..

echo "Setup is complete!"
