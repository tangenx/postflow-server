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

sed -i.bak "s/REPLACE_ME/$(openssl rand -hex 32)/" garage.toml

rm -f garage.toml.bak

docker compose -f $COMPOSE_FILE up -d --build s3
sleep 3

NODE_ID=$(docker compose -f $COMPOSE_FILE exec s3 /garage status 2>/dev/null \
  | awk '/NO ROLE ASSIGNED/{print $1; exit}')

echo "Node ID: $NODE_ID"

# Setting layout
docker compose -f $COMPOSE_FILE exec s3 /garage layout assign \
  -z dc1 -c 10G "$NODE_ID"
docker compose -f $COMPOSE_FILE exec s3 /garage layout apply --version 1

echo "Layout set"

# Creating bucket
docker compose -f $COMPOSE_FILE exec s3 /garage bucket create $BUCKET

echo "Bucket '$BUCKET' created"

# Creating API key
KEY_OUTPUT=$(docker compose -f $COMPOSE_FILE exec s3 /garage key create $KEY_NAME)

ACCESS_KEY=$(echo "$KEY_OUTPUT" | awk '/Key ID:/ {print $NF}')
SECRET_KEY=$(echo "$KEY_OUTPUT" | awk '/Secret key:/ {print $NF}')

# Assigning API key to bucket
docker compose -f $COMPOSE_FILE exec s3 /garage bucket allow \
  --read --write $BUCKET --key $KEY_NAME

sed -i.bak \
  -e "s/REPLACE_S3_ACCESS_KEY/$ACCESS_KEY/g" \
  -e "s/REPLACE_S3_SECRET_KEY/$SECRET_KEY/g" \
  -e "s/REPLACE_PASS/$(openssl rand -hex 16)/g" \
  -e "s/REPLACE_ME/$(openssl rand -base64 32)/g" \
  .env

rm -f .env.bak

docker compose -f $COMPOSE_FILE up -d --build