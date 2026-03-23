FROM postgres:18-alpine

COPY ./init_scripts/01-init.sql /docker-entrypoint-initdb.d/