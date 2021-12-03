#!/bin/bash -e

export APP_NAME="e2e_tests"
export PUBLISHED_PORT=${PUBLISHED_PORT:-"8020"}
./scripts/_run_.sh $@