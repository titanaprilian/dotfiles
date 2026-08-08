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

echo "Re-creating database '$DB_NAME' to ensure a clean restore..."
# We terminate any active connections to the database so we can drop it safely
docker exec -i $CONTAINER_NAME psql -U $DB_USER -d postgres -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$DB_NAME' AND pid <> pg_backend_pid();" > /dev/null 2>&1
docker exec -i $CONTAINER_NAME psql -U $DB_USER -d postgres -c "DROP DATABASE IF EXISTS $DB_NAME;" > /dev/null 2>&1
docker exec -i $CONTAINER_NAME psql -U $DB_USER -d postgres -c "CREATE DATABASE $DB_NAME;" > /dev/null 2>&1

echo "Restoring $SQL_FILE into database '$DB_NAME'..."

# Execute the restore
# We check if it is a custom-format dump by inspecting the file header (starts with PGDMP)
# We use 'sed'/'grep' to ignore common Supabase/Role errors to keep your output clean
if head -c 5 "$SQL_FILE" | grep -q "PGDMP"; then
    docker exec -i $CONTAINER_NAME pg_restore -U $DB_USER -d $DB_NAME < "$SQL_FILE" 2>&1 | \
    grep -v "role.*does not exist" | \
    grep -v "permission denied to change owner"
else
    docker exec -i $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME < "$SQL_FILE" 2>&1 | \
    grep -v "role.*does not exist" | \
    grep -v "permission denied to change owner"
fi

echo "Restore process completed."
