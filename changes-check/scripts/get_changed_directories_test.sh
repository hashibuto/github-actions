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
COUNT=$(echo $CHANGED_DIRECTORIES | jq length)
echo $CHANGED_DIRECTORIES | jq -e '.[]|select(. == "src/package/rooster")' > /dev/null
HAS_ROOSTER=$?
echo $CHANGED_DIRECTORIES | jq -e '.[]|select(. == "src/package/calculator")' > /dev/null
HAS_CALCULATOR=$?
if [ "$COUNT" != "2" ] || [ "$HAS_ROOSTER" != "0" ] || [ "$HAS_CALCULATOR" != "0" ]
then
    EXIT_CODE=1
    echo "fail"
else
    echo "pass"
fi

echo -n "testing get changed include filter.........................."
CHANGED_DIRECTORIES=$(cat ../data/file-list-nested.txt | ./get_changed_directories.sh "src/package/" "*.java" "")
COUNT=$(echo $CHANGED_DIRECTORIES | jq length)
echo $CHANGED_DIRECTORIES | jq -e '.[]|select(. == "src/package/rooster")' > /dev/null
HAS_ROOSTER=$?
if [ "$COUNT" != "1" ] || [ "$HAS_ROOSTER" != "0" ]
then
    EXIT_CODE=1
    echo "fail"
else
    echo "pass"
fi

echo -n "testing get changed multiple include filters................"
CHANGED_DIRECTORIES=$(cat ../data/file-list-multi.txt | ./get_changed_directories.sh "src/" "*.txt *pants*" "")
COUNT=$(echo $CHANGED_DIRECTORIES | jq length)
echo $CHANGED_DIRECTORIES | jq -e '.[]|select(. == "src/package")' > /dev/null
HAS_PAGCKAGE=$?
echo $CHANGED_DIRECTORIES | jq -e '.[]|select(. == "src/dest")' > /dev/null
HAS_DEST=$?
if [ "$COUNT" != "2" ] || [ "$HAS_ROOSTER" != "0" ]
then
    EXIT_CODE=1
    echo "fail"
else
    echo "pass"
fi

echo -n "testing get changed exclude filter.........................."
CHANGED_DIRECTORIES=$(cat ../data/file-list-multi.txt | ./get_changed_directories.sh "src/" "" "*.txt *pants*")
COUNT=$(echo $CHANGED_DIRECTORIES | jq length)
echo $CHANGED_DIRECTORIES | jq -e '.[]|select(. == "src/info")' > /dev/null
HAS_INFO=$?
if [ "$COUNT" != "1" ] || [ "$HAS_INFO" != "0" ]
then
    EXIT_CODE=1
    echo "fail"
else
    echo "pass"
fi
exit $EXIT_CODE
