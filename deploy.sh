#!/usr/bin/env bash

docker build -t corylogan/minio-distributed-kontena:latest .
docker push corylogan/minio-distributed-kontena
