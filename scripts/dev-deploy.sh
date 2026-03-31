#!/bin/bash

set -euo pipefail

COMPOSE_FILE=${1:-docker-compose.dev.yml}
BUCKET=${2:-anime-posting}
KEY_NAME=${3:-backend}

if [ ! -f .env ]; then
  echo "Copying .env.example to .env and generating secrets"
  cp .env.example .env

  sed -i.bak \
    -e "s|REPLACE_PASS|$(openssl rand -hex 16)|g" \
    -e "s|REPLACE_ME|$(openssl rand -base64 32)|g" \
    .env
fi

STORAGE_TYPE=$(grep '^STORAGE_TYPE=' .env | cut -d= -f2)

ADD_S3=$(if [ "$STORAGE_TYPE" == "s3" ]; then echo "--profile s3"; fi)

docker compose -f $COMPOSE_FILE $ADD_S3 up -d
sleep 3

if [ "$STORAGE_TYPE" == "s3" ]; then
  S3_KEY=$(grep '^S3_ACCESS_KEY=' .env | cut -d= -f2) 

  if [ "$S3_KEY" != "REPLACE_S3_ACCESS_KEY" ] && [ "$S3_KEY" != "" ]; then
    echo ""
    echo "Garage already initialized. Skipping"
    echo ""
    echo "If you are resetted Garage, remove S3_ACCESS_KEY and S3_SECRET_KEY secrets from .env and run this script again"
  else
    NODE_ID=$(docker compose -f $COMPOSE_FILE exec s3 /garage status 2>/dev/null \
    | awk '/NO ROLE ASSIGNED/{print $1; exit}')

    echo "Node ID: $NODE_ID"

    # Setting layout
    docker compose -f $COMPOSE_FILE exec s3 /garage layout assign \
      -z dc1 -c 10G "$NODE_ID" >/dev/null 2>&1
    docker compose -f $COMPOSE_FILE exec s3 /garage layout apply --version 1 >/dev/null 2>&1

    echo "Layout set"

    # Creating bucket
    docker compose -f $COMPOSE_FILE exec s3 /garage bucket create $BUCKET >/dev/null 2>&1

    echo "Bucket '$BUCKET' created"

    # Creating API key
    KEY_OUTPUT=$(docker compose -f $COMPOSE_FILE exec s3 /garage key create $KEY_NAME 2>/dev/null)

    ACCESS_KEY=$(echo "$KEY_OUTPUT" | awk '/Key ID:/ {print $NF}')
    SECRET_KEY=$(echo "$KEY_OUTPUT" | awk '/Secret key:/ {print $NF}')

    # Assigning API key to bucket
    docker compose -f $COMPOSE_FILE exec s3 /garage bucket allow \
      --read --write $BUCKET --key $KEY_NAME >/dev/null 2>&1

    sed -i.bak \
      -e "s|^S3_ACCESS_KEY=.*|S3_ACCESS_KEY=$ACCESS_KEY|"  \
      -e "s|^S3_SECRET_KEY=.*|S3_SECRET_KEY=$SECRET_KEY|" \
      -e "s|^S3_BUCKET=.*|S3_BUCKET=$BUCKET|g" \
      -e "s|^S3_ENDPOINT=.*|S3_ENDPOINT=http://localhost:3900|g" \
      .env

    echo ""
    echo "Garage initialized successfully."
    echo ""
    echo "These variables added to .env:"
    echo ""
    echo "  S3_ENDPOINT=http://localhost:3900"
    echo "  S3_REGION=garage"
    echo "  S3_BUCKET=$BUCKET"
    echo "  S3_ACCESS_KEY=$ACCESS_KEY"
    echo "  S3_SECRET_KEY=$SECRET_KEY"
    echo ""
    echo "If you are using VSCode debug, paste these variables to the launch.json"
    echo ""
  fi
fi

echo ""
echo "To start the server, run:"
echo ""
echo "  dart run bin/server.dart"
echo ""
echo "Or use VSCode debug"
echo ""

rm -f .env.bak