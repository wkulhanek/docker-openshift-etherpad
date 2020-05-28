#!/bin/bash
set -eux

# If the database is not "linked" then an external database is being
# used and the user is expected to set the following variables on the
# docker command line:
#
#   DB_TYPE - the type of database to be used (postgres, mysql, sqlite)
#   DB_HOST - The hostname to reach for the db
#   DB_PORT - The port where the db is listening
#   DB_DATABASE - The database name
#   DB_USER - The database username
#   DB_PASS - The database password

# Update the settings.json with appropriate values
# Having settings.json in its own config directory allows us to replace
# it at runtime with a ConfigMap
echo "Updating Settings File"
cp config/settings.json .
sed -i "s/DB_TYPE/${DB_TYPE}/" settings.json
sed -i "s/DB_HOST/${DB_HOST}/" settings.json
sed -i "s/DB_PORT/${DB_PORT}/" settings.json
sed -i "s/DB_DATABASE/${DB_DATABASE}/" settings.json
sed -i "s/DB_USER/${DB_USER}/" settings.json
sed -i "s/DB_PASS/${DB_PASS}/" settings.json

# Execute the etherpad provided startup script
./bin/run.sh $@
