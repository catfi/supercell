# - Try to find the APR libraries
# Once done this will define
#
# APRCORE_FOUND - system has APR Core
# APRCORE_INCLUDE_DIR - the APR Core include directory
# APRCORE_LIBRARIES - APR Core library

IF(WIN32)
    FIND_PATH(APRCORE_INCLUDE_DIR apr.h PATHS 
    	/usr/include/apr-1.0/
    	/usr/local/include/apr-1.0/ 
    	${CMAKE_SOURCE_DIR}/dep/windows/apr/include/
    	)
    IF(CMAKE_SIZEOF_VOID_P EQUAL 8)
        FIND_LIBRARY(APRCORE_LIBRARIES NAMES libapr-1 PATHS
        	${CMAKE_SOURCE_DIR}/dep/windows/apr/lib/x86-64
        	)
    ELSE()
        FIND_LIBRARY(APRCORE_LIBRARIES NAMES libapr-1 PATHS
        	${CMAKE_SOURCE_DIR}/dep/windows/apr/lib/x86
        	)
    ENDIF()
ELSE()
    FIND_PATH(APRCORE_INCLUDE_DIR apr.h PATHS 
    	/usr/include/apr-1.0/
    	/usr/local/include/apr-1.0/ 
    	${CMAKE_SOURCE_DIR}/dep/linux/apr/include/
    	)
    IF(CMAKE_SIZEOF_VOID_P EQUAL 8)
        FIND_LIBRARY(APRCORE_LIBRARIES NAMES apr-1 PATHS
        	${CMAKE_SOURCE_DIR}/dep/linux/apr/lib/x86-64
        	)
    ELSE()
        FIND_LIBRARY(APRCORE_LIBRARIES NAMES apr-1 PATHS
        	${CMAKE_SOURCE_DIR}/dep/linux/apr/lib/x86
        	)
    ENDIF()
ENDIF()

IF(APRCORE_INCLUDE_DIR AND APRCORE_LIBRARIES)
	SET(APRCORE_FOUND 1)
	IF(NOT APRCORE_FIND_QUIETLY)
		MESSAGE(STATUS "Found APRCORE: include = ${APRCORE_INCLUDE_DIR}, libraries = ${APRCORE_LIBRARIES}")
	ENDIF()
ELSE()
	SET(APRCORE_FOUND 0 CACHE BOOL "APRCORE not found")
	MESSAGE(STATUS "APRCORE not found, disabled")
ENDIF()

MARK_AS_ADVANCED(APRCORE_INCLUDE_DIR APRCORE_LIBRARIES)
