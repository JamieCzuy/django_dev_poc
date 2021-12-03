#!/bin/bash -e

echo ""
echo "Building (making) the database..."

docker-compose --file ./docker_files/docker-compose.yml up db