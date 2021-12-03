#!/bin/bash -e

# ---- Handle Command line options ---- #
export COMMAND_TO_RUN="${COMMAND_TO_RUN:-${@}}"

# ---- Handle other env vars ---- #
export APP_NAME=${APP_NAME:-"django_project"}
export CONTAINER_NAME=${CONTAINER_NAME:-${APP_NAME}}
export IMAGE_NAME=${IMAGE_NAME:-${APP_NAME}}
export PUBLISHED_PORT=${PUBLISHED_PORT:-"8000"}
export TARGET_FOLDER=${TARGET_FOLDER:-"/app"}

echo ""
echo "Running ${APP_NAME} in Docker:"
echo "    COMMAND_TO_RUN: ${COMMAND_TO_RUN}"
echo "    CONTAINER_NAME: ${CONTAINER_NAME}"
echo "    IMAGE_NAME: ${IMAGE_NAME}"
echo "    PUBLISHED_PORT: ${PUBLISHED_PORT}"
echo "    TARGET_FOLDER: ${TARGET_FOLDER}"

if [ "$(docker ps -q -f name=${CONTAINER_NAME})" ]; then
    echo ""
    echo "Killing existing container ${CONTAINER_NAME}..."
    docker kill ${CONTAINER_NAME} > /dev/null
fi
if [ "$(docker ps -aq -f name=${CONTAINER_NAME})" ]; then
    echo ""
    echo "Removing existing container ${CONTAINER_NAME}..."
    docker rm ${CONTAINER_NAME} > /dev/null
fi

echo ""
echo "Docker run..."

docker run \
    -it \
    --name ${CONTAINER_NAME} \
    --publish ${PUBLISHED_PORT}:8000 \
    --volume `pwd`/django_project:${TARGET_FOLDER} \
    ${IMAGE_NAME} \
    ${COMMAND_TO_RUN}

echo ""
echo "Done Running Docker Image: ${IMAGE_FULL_NAME}"
