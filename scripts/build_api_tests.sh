#!/bin/bash -e

export BUILD_TARGET="api_tests"
./scripts/_build_docker_image_.sh $@