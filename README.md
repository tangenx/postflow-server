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
4. Set `STORAGE_TYPE` to `s3` or `local`

If you are using `s3` storage type:

5. Replace `REPLACE_ME` in `garage.toml` with output
   from `openssl rand -hex 32`
6. Start only Garage: `docker compose -f docker-compose.yml --profile s3 up -d --build s3`
7. Remember the alias to your Garage:
   `docker compose -f docker-compose.yml exec s3 /garage`
8. Run following commands to initialize Garage:
   1. `status` - get node ID
   2. `layout assign -z dc1 -c 10G <NODE ID HERE>` - set layout
   3. `layout apply --version 1` - apply layout
   4. `bucket create <BUCKET NAME HERE>` - create bucket
   5. `key create <KEY NAME NAME>` - create API key
   6. <b>REMEMBER THE SECRET KEY - YOU CANNOT GET IT AGAIN</b>
   7. `bucket allow --read --write <BUCKET NAME HERE> --key <KEY NAME NAME>` - assign API key to bucket
   8. Add these to your `.env` file:

   ```env
   S3_ENDPOINT=http://s3:3900 # or localhost:3900 if you are using dev deploy
   S3_REGION=garage
   S3_BUCKET=BUCKET NAME HERE
   S3_ACCESS_KEY=KEY ID HERE
   S3_SECRET_KEY=SECRET KEY HERE
   ```

If you are using `local` storage type:

9. Update LOCAL_STORAGE_PATH in .env with your local storage path

Next steps:

10. Start the server with `docker compose -f docker-compose.yml up -d --build` for local storage or `docker compose -f docker-compose.yml --profile s3 up -d --build` for s3 storage
    (or `dart run bin/server.dart` for dev deploy)
11. Gg
