# Locate ActiveMQ-CPP include paths and libraries

# This module defines
# AMQ_INCLUDES, where to find *.h, etc.
# AMQ_LIBS, the libraries to link against to use ActiveMQ-CPP.
# AMQ_FLAGS, the flags to use to compile
# AMQ_FOUND, set to 'yes' if found

MESSAGE(STATUS "Looking for AMQ...")

find_program(AMQ_CONFIG_EXECUTABLE
    activemqcpp-config
    /usr/local/bin
    /usr/bin
    )

mark_as_advanced(AMQ_CONFIG_EXECUTABLE)

macro(_amq_invoke _varname _regexp)
    execute_process(
        COMMAND ${AMQ_CONFIG_EXECUTABLE} ${ARGN}
        OUTPUT_VARIABLE _amq_output
        RESULT_VARIABLE _amq_failed
    )

    if(_amq_failed)
        message(FATAL_ERROR "activemqcpp-config ${ARGN} failed")
    else(_amq_failed)
        string(REGEX REPLACE "[\r\n]"  "" _amq_output "${_amq_output}")
        string(REGEX REPLACE " +$"     "" _amq_output "${_amq_output}")

        if(NOT ${_regexp} STREQUAL "")
            string(REGEX REPLACE "${_regexp}" " " _amq_output "${_amq_output}")
        endif(NOT ${_regexp} STREQUAL "")

        separate_arguments(_amq_output)
        set(${_varname} "${_amq_output}")
    endif(_amq_failed)
endmacro(_amq_invoke)

_amq_invoke(AMQ_INCLUDES "(^| )-I" --includes)
_amq_invoke(AMQ_FLAGS    ""        --cflags)
_amq_invoke(AMQ_LIBS     ""        --libs)

if(AMQ_INCLUDES AND AMQ_LIBS)
    set(AMQ_FOUND "YES")
    message (STATUS "Found AMQ: libraries = ${AMQ_LIBS}")
endif(AMQ_INCLUDES AND AMQ_LIBS)
