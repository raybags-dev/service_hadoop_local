#!/bin/bash
# pull down existing image
docker compose down -v
# Create Docker volumes
docker volume create hadoop-data
docker volume create hadoop-namenode

# Start Hadoop cluster
docker compose up -d