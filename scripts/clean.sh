#!/bin/bash
echo "[clean.sh] Cleaning all Docker resources..."

docker images -q | xargs -r docker rmi -f
docker network prune -f
docker volume prune -f
docker builder prune -af

echo "[clean.sh] Docker cleanup completed."