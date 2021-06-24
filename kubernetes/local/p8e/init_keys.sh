#!/bin/bash

echo "creating p8e test affiliate keys"

psql -f /p8e/keys.sql postgres://$DB_USER:$DB_PASS@$DB_HOST:$DB_PORT/$DB_NAME