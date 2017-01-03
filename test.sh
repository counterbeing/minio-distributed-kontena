#!/usr/bin/env bash

docker-compose build
docker-compose run minio-distributed-kontena bats /test
