#!/bin/bash -e

echo "Using pytest to run API tests..."
echo "    < what options to use? >"
echo ""

pytest

echo ""
echo "Done running pytest"