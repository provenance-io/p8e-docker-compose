#!/bin/bash

docker exec -it p8e-postgres psql -U postgres -c "CREATE DATABASE \"$1\";"
docker exec -it p8e-postgres psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE \"$1\" TO postgres;"
docker exec -it p8e-postgres psql -U postgres $1 -c "CREATE SCHEMA \"$1\";"
docker exec -it p8e-postgres psql -U postgres $1 -c "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\" WITH SCHEMA \"$1\";"
docker exec -it p8e-postgres psql -U postgres -c "ALTER DATABASE \"$1\" SET search_path TO public,\"$1\";"
