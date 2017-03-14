#!/bin/bash

pushd $(dirname $(readlink -f $0)) > /dev/null

COMMIT=$(git log --pretty=oneline --abbrev-commit -n1 HEAD)

pushd webapp > /dev/null

# Build webapp
npm run build > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Build failed: $COMMIT "
    exit 1
fi

# Run tests for webapp
npm test > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Tests failed: $COMMIT "
    exit 1
fi

popd > /dev/null

# All is well
echo "OK: $COMMIT"

popd > /dev/null
