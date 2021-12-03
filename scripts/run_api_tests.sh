#!/bin/bash -e

export APP_NAME="api_tests"
export PUBLISHED_PORT=${PUBLISHED_PORT:-"8010"}
./scripts/_run_.sh $@