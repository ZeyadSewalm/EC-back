#!/bin/sh
set -e

echo "Waiting for database..."
until python -c "
import os, psycopg2
psycopg2.connect(
    dbname=os.environ.get('DB_NAME', 'omera'),
    user=os.environ.get('DB_USER', 'postgres'),
    password=os.environ.get('DB_PASSWORD', 'postgres'),
    host=os.environ.get('DB_HOST', 'db'),
    port=os.environ.get('DB_PORT', '5432'),
)
" 2>/dev/null; do
  sleep 2
done

echo "Running migrations..."
python manage.py migrate --noinput

echo "Starting server..."
exec "$@"
