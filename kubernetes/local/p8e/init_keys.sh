#!/bin/bash

echo "creating p8e test affiliate keys"

psql -U $DB_USER -h $DB_HOST -p $DB_PORT -d $DB_NAME -f /p8e/keys.sql