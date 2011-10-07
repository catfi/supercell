# - Try to find the Cassandra libraries
# Once done this will define
#
# CASSANDRA_FOUND - system has Cassandra
# CASSANDRA_INCLUDE_DIR - the Cassandra include directory
# CASSANDRA_LIBRARIES - Cassandra library

IF(NOT WIN32)
    FIND_PATH(CASSANDRA_INCLUDE_DIR Cassandra.h PATHS
        ${CMAKE_SOURCE_DIR}/dep/linux/cassandra/include
        )
ENDIF()

IF(CASSANDRA_INCLUDE_DIR)
    SET(CASSANDRA_FOUND 1)
    IF(NOT CASSANDRA_FOUND_QUIETLY)
        MESSAGE(STATUS "Found CASSANDRA: include = ${CASSANDRA_INCLUDE_DIR}, libraries = ${CASSANDRA_LIBRARIES}")
    ENDIF()
ELSE()
    SET(CASSANDRA_FOUND 0 CACHE BOOL "CASSANDRA not found")
    MESSAGE(STATUS "CASSANDRA not found, disabled")
ENDIF()

MARK_AS_ADVANCED(CASSANDRA_INCLUDE_DIR)
