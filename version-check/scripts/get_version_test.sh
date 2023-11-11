#!/usr/bin/env bash

echo -n "testing standard version file..............................."
VERSION=$(./get_version.sh ../data/standard-version-file 1 "")
if [ "$VERSION" != "v0.0.1" ]
then
    echo "fail"
else
    echo "pass"
fi

echo -n "testing pattern match version file.........................."
VERSION=$(./get_version.sh ../data/complex-version-file 1 "version = \"(.*)\"")
if [ "$VERSION" != "0.2.0" ]
then
    echo "fail"
else
    echo "pass"
fi

echo -n "testing pattern match version file specific occurrence......"
VERSION=$(./get_version.sh ../data/complex-version-file 2 "version = \"(.*)\"")
if [ "$VERSION" != "0.3.0" ]
then
    echo "fail"
else
    echo "pass"
fi