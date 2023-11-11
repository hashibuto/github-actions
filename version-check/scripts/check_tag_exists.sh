#!/usr/bin/env bash

VERSION="$1"
TAG_PREFIX="$2"

FULL_TAG=${TAG_PREFIX}${VERSION}

git show-ref --tags --verify --quiet "refs/tags/$FULL_TAG"
if [ "$?" == "0" ]
then
    echo "the tag ${FULL_TAG} already exists, please increment the version number"
    exit 1
fi
