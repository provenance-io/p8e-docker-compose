#!/bin/bash
set -e

P8E_WEBSERVICE_ENV_FILE=env/p8e/webservice/dynamic_env
PROVENANCE_PATH=provenance

# touch file so that docker-compose will link to it and startup p8e correctly
# the file contents will be added and p8e will be restarted later in this script
touch $P8E_WEBSERVICE_ENV_FILE

. bin/source
. bin/stop
. bin/update

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
    --gas auto \
    --fees 3000nhash \
    --broadcast-mode block \
    --yes \
    --testnet | jq
cd ..

docker-compose up -d p8e-postgres

# until docker exec -it postgres psql -U postgres -c "SELECT 1;" > /dev/null 2>&1; do
until docker exec -it p8e-postgres pg_isready --username=postgres --host=p8e-postgres > /dev/null 2>&1; do
	echo "waiting for postgres to be ready..."
	sleep 2
done

bin/create-all-dbs.sh
mkdir os_storage_bucket

docker-compose up p8e-migrate

docker exec -it p8e-postgres psql -U postgres p8e -f keys/p8e.sql

# TODO eliminate the need for this
echo "Writing dynamic configuration file for p8e..."
echo "*** POPULATE THE PROVENANCE_OAUTH_CLIENT_SECRET VALUE BELOW WITH THE SECRET FROM PROVENANCE TEST ***" > $P8E_WEBSERVICE_ENV_FILE
echo "PROVENANCE_OAUTH_CLIENT_SECRET=" >> $P8E_WEBSERVICE_ENV_FILE
echo "" >> $P8E_WEBSERVICE_ENV_FILE

. bin/stop

echo "Setup is complete!"
