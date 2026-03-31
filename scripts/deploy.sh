#!/bin/bash

# 1. Run garage
# 2. Create key
# 3. Fill in .env
# 4. Run all the other scripts

set -e

COMPOSE_FILE=${1:-docker-compose.yml}
BUCKET=${2:-anime-posting}
KEY_NAME=${3:-backend}

if [ ! -f .env ]; then
  cp .env.example .env
fi

STORAGE_TYPE=$(grep '^STORAGE_TYPE=' .env | cut -d= -f2)
S3_KEY=$(grep '^S3_ACCESS_KEY=' .env | cut -d= -f2) 

if [ "$STORAGE_TYPE" == "s3" ]; then
  if [ "$S3_KEY" == "REPLACE_S3_ACCESS_KEY" ] || [ "$S3_KEY" == "" ]; then
    echo "Initializing Garage S3 storage"

    sed -i.bak "s/REPLACE_ME/$(openssl rand -hex 32)/" garage.toml

    rm -f garage.toml.bak

    docker compose -f $COMPOSE_FILE --profile s3 up -d --build s3
    sleep 3

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
      -e "s/REPLACE_PASS/$(openssl rand -hex 16)/g" \
      -e "s/REPLACE_ME/$(openssl rand -base64 32)/g" \
      .env

    rm -f .env.bak
  fi
fi

echo "Starting server"
ADD_S3=$(if [ "$STORAGE_TYPE" == "s3" ]; then echo "--profile s3"; fi)

docker compose -f $COMPOSE_FILE $ADD_S3 up -d --build