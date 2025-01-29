#!/bin/bash

# Check for the presence of the database and drop it if ncessary. 
if PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -U $POSTGRES_USER -d $POSTGRES_DB -c '\dt' > /dev/null 2>&1; then
  echo "Database $POSTGRES_DB does not exist. Creating it..."
  mix ecto.drop
fi

# Check for the presence of the database and create it if necessary.
if ! PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -U $POSTGRES_USER -d $POSTGRES_DB -c '\dt' > /dev/null 2>&1; then
  echo "Database $POSTGRES_DB does not exist. Creating it..."
  mix ecto.create
fi

# Wait until the database container is usable.
DB_CONTAINER_NAME="postgres"
until pg_isready -h $POSTGRES_HOST -U $POSTGRES_USER; do
  echo "Waiting for the database container to be ready..."
  sleep 2
done

# Run migrations and launch the application.
mix ecto.migrate
mix phx.server
