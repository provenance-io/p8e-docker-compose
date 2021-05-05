#!/bin/bash

DATABASES=(
  "object_store"
  "object-store"
  "mailbox"
  "p8e"
)

for db in "${DATABASES[@]}"; do
	./bin/create-db.sh $db
done
