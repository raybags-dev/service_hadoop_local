#!/bin/bash

docker compose down -v
docker volume rm hadoop-data hadoop-namenode
