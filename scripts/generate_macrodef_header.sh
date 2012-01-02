#!/bin/sh

STRING_FILE=$1
HEADER_FILE=$2
MACRO_NAME=$3

STRING_LITERAL=`cat ${STRING_FILE} | sed 's/\"/\\\"/g' | tr '\n' '~' | sed 's/~/\\\\\\\n\" \\\\\n\"/g'`
echo "#define ${MACRO_NAME} \"${STRING_LITERAL}\"" > ${HEADER_FILE}
