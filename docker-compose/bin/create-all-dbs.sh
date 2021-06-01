#!/bin/bash

DATABASES=(
  "object-store"
  "p8e"
)

for db in "${DATABASES[@]}"; do
	./bin/create-db.sh $db
done
