#!/bin/bash

set -e

export $(cat ./hadoop.env | xargs)

docker compose down -v

if docker volume ls -q | grep -wq "hadoop-data"; then
    docker volume rm hadoop-data
fi

if docker volume ls -q | grep -wq "hadoop-namenode"; then
    docker volume rm hadoop-namenode
fi
