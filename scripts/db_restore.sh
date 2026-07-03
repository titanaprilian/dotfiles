#!/bin/bash

# Configuration
CONTAINER_NAME="local_postgres"
DB_USER="postgres"

# Check if arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: ./db_restore.sh <database_name> <sql_file>"
    exit 1
fi

DB_NAME=$1
SQL_FILE=$2

# Check if file exists
if [ ! -f "$SQL_FILE" ]; then
    echo "Error: File $SQL_FILE not found!"
    exit 1
fi

echo "Restoring $SQL_FILE into database '$DB_NAME'..."

# Execute the restore
# We use 'sed' to ignore common Supabase/Role errors to keep your output clean
docker exec -i $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME < "$SQL_FILE" 2>&1 | \
grep -v "role.*does not exist" | \
grep -v "permission denied to change owner"

echo "Restore process completed."
