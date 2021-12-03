#!/bin/bash -e

export BUILD_TARGET="e2e_tests"
./scripts/_build_docker_image_.sh $@