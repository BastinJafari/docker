#!/bin/bash
set -e # exit on error

BUILD_ENV_PATH="$REPOSITORY_PATH/.env"

echo "───────────────────────────────────────────────"
echo "📦 Now we need to get some information about the instance you are building."
echo
read -p "What are you going to name your instance? " DECIDIM_APPLICATION_NAME
echo "The name of the instance is: $DECIDIM_APPLICATION_NAME"
echo
echo "Who's going to administer this instance?"
read -p "email: " DECIDIM_SYSTEM_ADMIN_EMAIL
read -p "name: " DECIDIM_SYSTEM_ADMIN_NAME
echo "The administrator will be $DECIDIM_SYSTEM_ADMIN_NAME, $DECIDIM_SYSTEM_ADMIN_EMAIL"
echo
echo "Now we need to know how people will access this instance (e.g., decidim.example.org)"
read -p "domain: " DECIDIM_DOMAIN

echo "───────────────────────────────────────────────"
echo "To set up the Database we also need some information"
read -p "Do you have an external database already set up? [y/N] " yn

case $yn in
[Yy]*)
  EXTERNAL_DATABASE=true
  ;;
[Nn]*)
  EXTERNAL_DATABASE=false
  ;;
*)
  echo "Please answer yes or no."
  exit 1
  ;;
esac

read -p "Name of the database: " DATABASE_NAME
read -p "Database user: " DATABASE_USER

if [ "$EXTERNAL_DATABASE" = true ]; then
  read -p "Database host (ip or domain): " DATABASE_HOST
else
  DATABASE_HOST="db"
fi

read -p "Database password: " DATABASE_PASSWORD

DATABASE_URL="postgres://$DATABASE_USER:$DATABASE_PASSWORD@$DATABASE_HOST/$DATABASE_NAME"

echo "───────────────────────────────────────────────"
echo "Now we have to set your SMTP server."
echo "You can check the documentation to know what to do here."
read -p "SMTP_USERNAME: " SMTP_USERNAME
read -p "SMTP_PASSWORD: " SMTP_PASSWORD
read -p "SMTP_ADDRESS: " SMTP_ADDRESS
read -p "SMTP_DOMAIN: " SMTP_DOMAIN

echo "───────────────────────────────────────────────"
echo "To start, we are going to store assets locally"
read -p "Do you have an external database already set up? [y/N] " yn
STORAGE="local"

echo "───────────────────────────────────────────────"
echo "To be able to have the maps working inside the Decidim application,"
echo "is necessary to configure a maps provider."
read -p "Maps provider: " MAPS_PROVIDER
read -p "Maps API KEY: " MAPS_API_KEY

if [ -f .env ]; then
  echo "❌ Failing: .env file already exists."
  exit 1
else
  echo "✅ Writing the environment variables to .env file..."

  cat >.env <<EOF
DECIDIM_IMAGE=$DECIDIM_IMAGE
DECIDIM_APPLICATION_NAME="$DECIDIM_APPLICATION_NAME"
DECIDIM_SYSTEM_ADMIN_EMAIL="$DECIDIM_SYSTEM_ADMIN_EMAIL"
DECIDIM_SYSTEM_ADMIN_NAME="$DECIDIM_SYSTEM_ADMIN_NAME"
DECIDIM_DOMAIN="$DECIDIM_DOMAIN"

POSTGRES_DB="$DATABASE_NAME"
POSTGRES_NAME="$DATABASE_USER"
DATABASE_HOST="$DATABASE_HOST"
POSTGRES_PASSWORD="$DATABASE_PASSWORD"
DATABASE_URL="$DATABASE_URL"

SMTP_USERNAME="$SMTP_USERNAME"
SMTP_PASSWORD="$SMTP_PASSWORD"
SMTP_ADDRESS="$SMTP_ADDRESS"
SMTP_DOMAIN="$SMTP_DOMAIN"

MAPS_PROVIDER="$MAPS_PROVIDER"
MAPS_API_KEY="$MAPS_API_KEY"
EOF
fi

echo "✅ All environment variables saved to .env successfully!"
