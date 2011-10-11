#!/bin/sh

PTX_FILE=$1
PTX_ENTRY_POINT_HINT=$2

# get demangled name from hint
FN_DEMANGLED_NAME=`cat ${PTX_FILE} | grep '.entry' | cut -d' ' -f2 | xargs c++filt --no-params | grep ${PTX_ENTRY_POINT_HINT} | tr -d '\n'`

# extract deepest level namespace (Ex. "c" from "a::b::c")
SEGMENT_COUNT=`echo ${FN_DEMANGLED_NAME} | sed 's/::/\n/g' | wc -l`
if [ ${SEGMENT_COUNT} != 0 ]; then
    FN_DEMANGLED_NAME=`echo ${FN_DEMANGLED_NAME} | sed 's/::/:/g' | cut -d':' -f${SEGMENT_COUNT}`
fi

# get mangled name from demangled name
FN_MANGLED_NAME=`cat ${PTX_FILE} | grep '.entry' | cut -d' ' -f2 | grep ${FN_DEMANGLED_NAME} | tr -d '\n'`

echo ${FN_MANGLED_NAME}
