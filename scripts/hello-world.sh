#!/bin/bash
set -e

# This is the entrypoint script for the 'decidim' service.
#
# It checks if the database exists and if not, it will be created,
# migrated and seeded. After that, it will run whatever command
# is passed to it.
#
# This is useful so we don't have to worry about running commands on the
# file when we create the app for the first time and migrations haven't
# been run yet.

echo '-----------------------------------------------'
echo ''
echo 'Done! Starting your Decidim instance!          '
echo '-----------------------------------------------'

exec "$@"
