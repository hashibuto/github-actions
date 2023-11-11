#!/usr/bin/env bash

EXIT_CODE=0

echo -n "testing get changed directories............................."
CHANGED_DIRECTORIES=$(cat ../data/file-list-standard.txt | ./get_changed_directories.sh "" "" "")
COUNT=$(echo $CHANGED_DIRECTORIES | jq length)
echo $CHANGED_DIRECTORIES | jq -e '.[]|select(. == "package")' > /dev/null
HAS_PACKAGE=$?
echo $CHANGED_DIRECTORIES | jq -e '.[]|select(. == "module")' > /dev/null
HAS_MODULE=$?
echo $CHANGED_DIRECTORIES | jq -e '.[]|select(. == "list")' > /dev/null
HAS_LIST=$?
if [ "$COUNT" != "3" ] || [ "$HAS_PACKAGE" != "0" ] || [ "$HAS_MODULE" != "0" ] || [ "$HAS_LIST" != "0" ]
then
    EXIT_CODE=1
    echo "fail"
else
    echo "pass"
fi

echo -n "testing get nested changed directories top level............"
CHANGED_DIRECTORIES=$(cat ../data/file-list-nested.txt | ./get_changed_directories.sh "" "" "")
COUNT=$(echo $CHANGED_DIRECTORIES | jq length)
echo $CHANGED_DIRECTORIES | jq -e '.[]|select(. == "src")' > /dev/null
HAS_SRC=$?
if [ "$COUNT" != "1" ] || [ "$HAS_SRC" != "0" ]
then
    EXIT_CODE=1
    echo "fail"
else
    echo "pass"
fi

echo -n "testing get changed nested.................................."
CHANGED_DIRECTORIES=$(cat ../data/file-list-nested.txt | ./get_changed_directories.sh "src/" "" "")
COUNT=$(echo $CHANGED_DIRECTORIES | jq length)
echo $CHANGED_DIRECTORIES | jq -e '.[]|select(. == "src/package")' > /dev/null
HAS_PACKAGE=$?
echo $CHANGED_DIRECTORIES | jq -e '.[]|select(. == "src/module")' > /dev/null
HAS_MODULE=$?
echo $CHANGED_DIRECTORIES | jq -e '.[]|select(. == "src/list")' > /dev/null
HAS_LIST=$?
if [ "$COUNT" != "3" ] || [ "$HAS_PACKAGE" != "0" ] || [ "$HAS_MODULE" != "0" ] || [ "$HAS_LIST" != "0" ]
then
    EXIT_CODE=1
    echo "fail"
else
    echo "pass"
fi

echo -n "testing get changed double nested..........................."
CHANGED_DIRECTORIES=$(cat ../data/file-list-nested.txt | ./get_changed_directories.sh "src/package/" "" "")
echo $CHANGED_DIRECTORIES
COUNT=$(echo $CHANGED_DIRECTORIES | jq length)
echo $CHANGED_DIRECTORIES | jq -e '.[]|select(. == "src/package/rooster")' > /dev/null
HAS_ROOSTER=$?
echo $CHANGED_DIRECTORIES | jq -e '.[]|select(. == "src/module/caculator")' > /dev/null
HAS_CALCULATOR=$?
echo $CHANGED_DIRECTORIES | jq -e '.[]|select(. == "src/list")' > /dev/null
HAS_LIST=$?
if [ "$COUNT" != "2" ] || [ "$HAS_ROOSTER" != "0" ] || [ "$HAS_CALCULATOR" != "0" ]
then
    EXIT_CODE=1
    echo "fail"
else
    echo "pass"
fi

exit $EXIT_CODE
