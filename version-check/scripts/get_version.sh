#!/usr/bin/env bash

FILENAME="$1"
OCCURRENCE="$2"
EXPRESSION="$3"

if [ "$EXPRESSION" == "" ]
then
    VERSION=$(cat $FILENAME)
else
    EXP='s/'${EXPRESSION}'/\1/p'
    VERSION=$(cat $FILENAME | sed -nr "$EXP" | sed -n ${OCCURRENCE}p )
fi

echo $VERSION