export MODULE_NAME=${1:-${MODULE_NAME:-"app"}}

export BUILD_TARGET=${BUILD_TARGET:-"${MODULE_NAME}_update_requirements"}
export IMAGE_NAME=${IMAGE_NAME:-${BUILD_TARGET}}

# NOTE: The update_requirements build target actually
#       creates a new requirements.txt (compiles .src)
./scripts/_build_docker_image_.sh $@

# NOTE: This docker run command is just copying that
#       new requirements.txt so it can be checked into git
docker run \
    --name ${IMAGE_NAME} \
    --rm \
    --volume `pwd`/${MODULE_NAME}:/${MODULE_NAME} \
    ${IMAGE_NAME} \
    cp /tmp/${MODULE_NAME}/requirements.txt /${MODULE_NAME}