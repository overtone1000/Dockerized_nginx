#!/bin/bash

set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

echo "Allowing processes to start"
sleep 5

echo "Starting cron"
service cron start

echo "Starting php$PHP_VERSION-fpm in background"
service php$PHP_VERSION-fpm start
service --status-all

echo "Starting nginx in foreground"
nginx -t
nginx -g "daemon off;"

function success()
{
echo "Configuration successful."
}
trap success EXIT