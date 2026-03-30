# Postflow Server

<div align="center">

[![Dart v3.11.2](https://img.shields.io/badge/dart-v3.11.2-blue "Thank you, Dart!")](https://dart.dev)

</div>

This is a server for [Postflow](https://github.com/tangenx/postflow-client)
client - a desktop app for managing your anime posting workflow.

## Epic guide for deploy

### Automatic

1. Run `./scripts/deploy.sh` (or `./scripts/dev-deploy.sh` for dev deploy)
2. For dev deploy - run `dart run bin/server.dart`
3. Gg

### Manual

1. Clone `.env.example` contents to `.env`
2. Replace `DB_PASSWORD` with your password
   (or generate a random one with `openssl rand -hex 16`)
3. Replace `JWT_SECRET` with secret from `openssl rand -hex 32`
4. Replace `REPLACE_ME` in `garage.toml` with output
   from `openssl rand -base64 32`
5. Start only Garage: `docker compose -f docker-compose.yml up -d --build s3`
6. Remember the alias to your Garage:
   `docker compose -f docker-compose.yml exec s3 /garage`
7. Run following commands to initialize Garage:

   a. `status` - get node ID
   b. `layout assign -z dc1 -c 10G <NODE ID HERE>` - set layout
   c. `layout apply --version 1` - apply layout
   d. `bucket create <BUCKET NAME HERE>` - create bucket
   e. `key create <KEY NAME NAME>` - create API key
   f. <b>REMEMBER THE SECRET KEY - YOU CANNOT GET IT AGAIN</b>
   g. `bucket allow --read --write <BUCKET NAME HERE> --key <KEY NAME NAME>` - assign API key to bucket
   h. Add these to your `.env` file:

   ```env
   S3_ENDPOINT=http://localhost:3900
   S3_REGION=garage
   S3_BUCKET=BUCKET NAME HERE
   S3_ACCESS_KEY=KEY ID HERE
   S3_SECRET_KEY=SECRET KEY HERE
   ```

8. with `docker compose -f docker-compose.yml up -d --build`
   (or `dart run bin/server.dart` for dev deploy)
9. Gg
