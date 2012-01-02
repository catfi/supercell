#!/bin/sh

FILE=$1

# proper indent using vim
(echo ":normal gg=G"; echo 'wq') | ex -s $FILE

# delete empty lines
TEMP_FILE=`mktemp`
cat $FILE | sed "/^$/d" > $TEMP_FILE
cat $TEMP_FILE > $FILE
