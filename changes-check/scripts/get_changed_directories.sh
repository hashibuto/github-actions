#!/usr/bin/env bash

PATH_PREFIX="$1"
INCLUDE="$2"
EXCLUDE="$3"

# receives a list of changes from the stdin
CHANGED_DIRS=()
FILE_LIST=$(cat)
for CHANGED in $FILE_LIST
do
    echo $FILE_LIST
    if [ "$INCLUDE" != "" ]
    then
        read -r -a INCLUDE_ARR <<< $INCLUDE
        MATCH=0
        for PATTERN in ${INCLUDE_ARR[@]}
        do
            if [[ $CHANGED == $PATTERN ]]
            then
                MATCH=1
            fi
        done
        if [ "$MATCH" == "0" ]
        then
            continue
        fi
    fi

    if [ "$EXCLUDE" != "" ]
    then
        read -r -a EXCLUDE_ARR <<< $EXCLUDE
        MATCH=1
        for PATTERN in ${EXCLUDE_ARR[@]}
        do
            if [[ $CHANGED == $PATTERN ]]
            then
                MATCH=0
                break
            fi
        done
        if [ "$MATCH" == "0" ]
        then
            continue
        fi
    fi

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
    if [ $DIRNAME == $CHANGED ]
    then
        continue
    fi

    if [[ ${CHANGED_DIRS[@]} =~ $DIRNAME ]] 
    then
        continue
    fi

    CHANGED_DIRS[${#CHANGED_DIRS[@]}]=$DIRNAME
done

# convert array to json list
printf '%s\n' "${CHANGED_DIRS[@]}" | jq -R . | jq -cs .