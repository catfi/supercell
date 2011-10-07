# - Try to find the ANN libraries
# Once done this will define
#
# ANN_FOUND - system has ANN
# ANN_INCLUDE_DIR - the ANN include directory
# ANN_LIBRARIES - ANN library

IF(NOT WIN32)
    FIND_PATH(ANN_INCLUDE_DIR ANN.h PATHS
        /usr/include/ANN
        )
    IF(CMAKE_SIZEOF_VOID_P EQUAL 8)
        FIND_LIBRARY(ANN_LIBRARIES NAMES ann PATHS
            /usr/lib64
            )
    ELSE()
        FIND_LIBRARY(ANN_LIBRARIES NAMES ann PATHS
            /usr/lib
            )
    ENDIF()
ENDIF()

IF(ANN_INCLUDE_DIR)
    SET(ANN_FOUND 1)
    IF(NOT ANN_FOUND_QUIETLY)
        MESSAGE(STATUS "Found ANN: include = ${ANN_INCLUDE_DIR}, libraries = ${ANN_LIBRARIES}")
    ENDIF()
ELSE()
    SET(ANN_FOUND 0 CACHE BOOL "ANN not found")
    MESSAGE(STATUS "ANN not found, disabled")
ENDIF()

MARK_AS_ADVANCED(ANN_INCLUDE_DIR ANN_LIBRARIES)
