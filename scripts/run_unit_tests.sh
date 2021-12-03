#!/bin/bash -e

export APP_NAME="unit_tests"
export PUBLISHED_PORT=${PUBLISHED_PORT:-"8030"}
./scripts/_run_.sh $@