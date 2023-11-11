#!/usr/bin/env bash

PATH_PREFIX="$1"
INCLUDE="$2"
EXCLUDE="$3"

# receives a list of changes from the stdin
CHANGED_DIRS=()
FILE_LIST=$(cat)
for CHANGED in $FILE_LIST
do
    ITEM=""
    if [ "$PATH_PREFIX" == "" ]
    then
        ITEM=$CHANGED
        
    else
        if [[ "$CHANGED" == $PATH_PREFIX* ]]
        then
            ITEM=${CHANGED#"$PATH_PREFIX"}
        fi
    fi

    if [ "$ITEM" == "" ]
    then
        continue
    fi

    DIRNAME=$PATH_PREFIX$(echo $ITEM | cut -d "/" -f 1)
    if [[ ${CHANGED_DIRS[@]} =~ $DIRNAME ]] 
    then
        continue
    fi

    CHANGED_DIRS[${#CHANGED_DIRS[@]}]=$DIRNAME
done

# convert array to json list
printf '%s\n' "${CHANGED_DIRS[@]}" | jq -R . | jq -s .