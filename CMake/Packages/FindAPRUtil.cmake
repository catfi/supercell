# - Try to find the APR libraries
# Once done this will define
#
# APRUTIL_FOUND - system has APR Utility
# APRUTIL_INCLUDE_DIR - the APR Utility include directory
# APRUTIL_LIBRARIES - APR Utility library

IF(WIN32)
    FIND_PATH(APRUTIL_INCLUDE_DIR apu.h PATHS 
    	/usr/include/apr-1.0/
    	/usr/local/include/apr-1.0/
    	${CMAKE_SOURCE_DIR}/dep/windows/apr/include/
    	)
    IF(CMAKE_SIZEOF_VOID_P EQUAL 8)
        FIND_LIBRARY(APRUTIL_LIBRARIES NAMES libaprutil-1 PATHS
        	${CMAKE_SOURCE_DIR}/dep/windows/apr/lib/x86-64
        	)
    ELSE()
        FIND_LIBRARY(APRUTIL_LIBRARIES NAMES libaprutil-1 PATHS
            ${CMAKE_SOURCE_DIR}/dep/windows/apr/lib/x86
            )
    ENDIF()
ELSE()
    FIND_PATH(APRUTIL_INCLUDE_DIR apu.h PATHS 
    	/usr/include/apr-1.0/
    	/usr/include/apr-1/
    	/usr/local/include/apr-1.0/
    	/usr/local/include/apr-1/
    	${CMAKE_SOURCE_DIR}/dep/linux/apr/include/
    	)
    IF(CMAKE_SIZEOF_VOID_P EQUAL 8)
        FIND_LIBRARY(APRUTIL_LIBRARIES NAMES aprutil-1 PATHS
        	${CMAKE_SOURCE_DIR}/dep/linux/apr/lib/x86-64
        	)
    ELSE()
        FIND_LIBRARY(APRUTIL_LIBRARIES NAMES aprutil-1 PATHS
            ${CMAKE_SOURCE_DIR}/dep/linux/apr/lib/x86
            )
    ENDIF()
ENDIF()

IF(APRUTIL_INCLUDE_DIR AND APRUTIL_LIBRARIES)
	SET(APRUTIL_FOUND 1)
	IF(NOT APRUTIL_FIND_QUIETLY)
		MESSAGE(STATUS "Found APRUTIL: include = ${APRUTIL_INCLUDE_DIR}, libraries = ${APRUTIL_LIBRARIES}")
	ENDIF()
ELSE()
	SET(APRUTIL_FOUND 0 CACHE BOOL "APRUTIL not found")
	MESSAGE(STATUS "APRUTIL not found, disabled")
ENDIF()

MARK_AS_ADVANCED(APRUTIL_INCLUDE_DIR APRUTIL_LIBRARIES)
