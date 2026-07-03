#!/bin/bash

# Configuration
CONTAINER_NAME="local_postgres"
DB_NAME="siakad"
NEW_HASHED_PASSWORD='$2a$10$PFjKQGUkIg.WuKIr3HqP1el2Dn.RLz33UtRTsv.bPeUN7AftP71Zu' 

echo "Updating all users in the 'users' table to a new password..."

# Run the update directly in Postgres
docker exec -i $CONTAINER_NAME psql -U postgres -d $DB_NAME -c \
"UPDATE users SET password = '$NEW_HASHED_PASSWORD';"

echo "All application user passwords have been updated."
