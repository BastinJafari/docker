#!/bin/bash

export $(cat .env | xargs)
composes="-f app.yml -f traefik.yml -f cache.yml -f worker.yml "

if $EXTERNAL_DATABASE; then
  composes+="-f db.yml"
fi

docker compose --env-file .env ${composes} up
