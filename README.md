# Postflow Server

<div align="center">

[![Dart v3.11.2](https://img.shields.io/badge/dart-v3.11.2-blue "Thank you, Dart!")](https://dart.dev)

</div>

## Epic guide for deploy

### Automatic

1. Run `./scripts/generate-secrets.sh`
2. Deploy with docker (docker compose up -d --build)

### Manual

1. Clone `.env.example` contents to `.env`
2. Replace `DB_PASSWORD` with your password
   (or generate a random one with `openssl rand -hex 16`)
3. Replace `JWT_SECRET` with secret from `openssl rand -hex 32`
4. Run server with `dart build cli` and run it somewhere in `build` folder
