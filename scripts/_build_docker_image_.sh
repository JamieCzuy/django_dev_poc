#!/bin/bash -e

# ---- Options that are usually "passed in" ---- #
export DOCKER_FILE=${DOCKER_FILE:-"Dockerfile"}
export BUILD_TARGET=${BUILD_TARGET:-"docker_project"}
export IMAGE_NAME=${IMAGE_NAME:-${BUILD_TARGET}}

# ---- Options that are not usually "passed in" ---- #
export GIT_HASH=$(git rev-parse --short HEAD)
if [[ `git status --porcelain` ]]; then
    GIT_HASH+="_mod"
fi
export PROGRESS_OPTION=${PROGRESS_OPTION:-"auto"}
export TIME_STAMP=$(date '+%y%m%d_%H%M%S')

echo ""
echo "Build ${IMAGE_NAME} docker image..."
echo ""
echo "Using:"
echo "    BUILD_TARGET: ${BUILD_TARGET}"
echo "    DOCKER_FILE: ${DOCKER_FILE}"
echo "    GIT_HASH: ${GIT_HASH}"
echo "    IMAGE_NAME: ${IMAGE_NAME}"
echo "    PROGRESS_OPTION: ${PROGRESS_OPTION}"
echo "    TIME_STAMP: ${TIME_STAMP}"


echo ""
echo "Building..."
docker build \
    --progress ${PROGRESS_OPTION} \
    --file ${DOCKER_FILE} \
    --tag ${IMAGE_NAME} \
    --tag ${IMAGE_NAME}:${GIT_HASH} \
    --tag ${IMAGE_NAME}:${TIME_STAMP} \
    --target ${BUILD_TARGET} \
    .

echo "Done building: ${IMAGE_NAME}"