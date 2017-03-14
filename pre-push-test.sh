#!/bin/bash

pushd $(dirname $(readlink -f $0)) > /dev/null

echo "> Pulling from master and ff merging"
git pull --ff-only
if [ $? -ne 0 ]; then
    exit 1
fi

echo "> Building and testing all local commits"
git rebase -q --exec ./build-all.sh origin/master 2>&1 \
    | sed '/Executing/d' \
    | sed '/Successfully rebased/d'
if [ $? -ne 0 ]; then
    exit 1
fi

popd > /dev/null
