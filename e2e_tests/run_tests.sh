#!/bin/bash -e

echo "Using pytest to run e2e tests..."
echo "    < what options to use? >"
echo ""

pytest

echo ""
echo "Done running pytest"