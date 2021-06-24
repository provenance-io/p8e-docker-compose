#!/bin/bash
set -e

. bin/source
. bin/stop-k8s
. bin/update-k8s

docker-compose up -d p8e-postgres

# until docker exec -it postgres psql -U postgres -c "SELECT 1;" > /dev/null 2>&1; do
until docker exec -it p8e-postgres pg_isready --username=postgres --host=p8e-postgres > /dev/null 2>&1; do
	echo "waiting for postgres to be ready..."
	sleep 2
done

bin/create-all-dbs.sh
mkdir -p os_storage_bucket

docker-compose up p8e-migrate

docker exec -it p8e-postgres psql -U postgres p8e -f keys/p8e.sql

. bin/stop-k8s

echo "Setup is complete!"
