#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [ ! -f .env ]; then
  cp .env.example .env
fi

sed -i.bak "s/REPLACE_ME/$(openssl rand -hex 32)/" garage.toml
sed -i.bak \
  -e "s/REPLACE_PASS/$(openssl rand -hex 16)/g" \
  -e "s/REPLACE_ME/$(openssl rand -base64 32)/g" \
  .env

rm -f .env.bak garage.toml.bak
