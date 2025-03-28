#!/bin/bash
echo "[stop.sh] Stopping all running Docker containers..."

docker ps -q | xargs -r docker stop
docker ps -a -q | xargs -r docker rm

echo "[stop.sh] All Docker containers stopped and removed."