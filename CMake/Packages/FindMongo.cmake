# - Try to find the Mongo libraries
# Once done this will define
#
# MONGO_FOUND - system has Mongo
# MONGO_INCLUDE_DIR - the Mongo include directory
# MONGO_LIBRARIES - Mongo library

IF(NOT WIN32)
    FIND_PATH(MONGO_INCLUDE_DIR mongo/client/dbclient.h PATHS
        ${CMAKE_SOURCE_DIR}/dep/linux/mongodb/
        )

    SET(MONGO_INCLUDE_DIR ${MONGO_INCLUDE_DIR} CACHE PATH "Mongo include directory" FORCE) # cache result

    FIND_LIBRARY(MONGO_LIBRARIES_MONGOCLIENT NAMES mongoclient PATHS
        ${CMAKE_SOURCE_DIR}/dep/linux/mongodb/mongodb-lib
        )
ENDIF()

IF(MONGO_INCLUDE_DIR AND MONGO_LIBRARIES_MONGOCLIENT)
    SET(MONGO_FOUND 1)
    SET(MONGO_LIBRARIES ${MONGO_LIBRARIES_MONGOCLIENT})
    IF(NOT MONGO_FIND_QUIETLY)
        MESSAGE(STATUS "Found MONGO: include = ${MONGO_INCLUDE_DIR}, libraries = ${MONGO_LIBRARIES}")
    ENDIF()
ELSE()
    SET(MONGO_FOUND 0 CACHE BOOL "MONGO not found")
    MESSAGE(STATUS "MONGO not found, disabled")
ENDIF()

MARK_AS_ADVANCED(MONGO_INCLUDE_DIR MONGO_LIBRARIES)
