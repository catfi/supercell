# - Try to find the LOG4CXX libraries
# Once done this will define
#
# LOG4CXX_FOUND - system has LOG4CXX
# LOG4CXX_INCLUDE_DIR - the LOG4CXX include directory
# LOG4CXX_LIBRARIES - LOG4CXX library

IF(WIN32)
    FIND_PATH(LOG4CXX_INCLUDE_DIR logger.h PATHS 
    	/usr/include/ 
    	/usr/local/include/ 
    	${CMAKE_SOURCE_DIR}/dep/windows/log4cxx/include
    	PATH_SUFFIXES "log4cxx"
    	)
    IF(CMAKE_SIZEOF_VOID_P EQUAL 8)
        FIND_LIBRARY(LOG4CXX_LIBRARIES NAMES log4cxx PATHS
        	${CMAKE_SOURCE_DIR}/dep/windows/log4cxx/lib/x86-64
        	)
    ELSE()
        FIND_LIBRARY(LOG4CXX_LIBRARIES NAMES log4cxx PATHS
        	${CMAKE_SOURCE_DIR}/dep/windows/log4cxx/lib/x86
        	)
    ENDIF()
ELSE()
    FIND_PATH(LOG4CXX_INCLUDE_DIR logger.h PATHS 
    	/usr/include/ 
    	/usr/local/include/ 
    	${CMAKE_SOURCE_DIR}/dep/linux/log4cxx/include
    	PATH_SUFFIXES "log4cxx"
    	)
    IF(CMAKE_SIZEOF_VOID_P EQUAL 8)
        FIND_LIBRARY(LOG4CXX_LIBRARIES NAMES log4cxx PATHS
        	${CMAKE_SOURCE_DIR}/dep/linux/log4cxx/lib/x86-64
        	)
    ELSE()
        FIND_LIBRARY(LOG4CXX_LIBRARIES NAMES log4cxx PATHS
        	${CMAKE_SOURCE_DIR}/dep/linux/log4cxx/lib/x86
        	)
    ENDIF()
ENDIF()

IF(LOG4CXX_INCLUDE_DIR AND LOG4CXX_LIBRARIES)
    SET(LOG4CXX_FOUND 1)
    
    STRING(REGEX REPLACE "/log4cxx$" "" LOG4CXX_INCLUDE_DIR_SUP ${LOG4CXX_INCLUDE_DIR})
    SET(LOG4CXX_INCLUDE_DIR ${LOG4CXX_INCLUDE_DIR_SUP} CACHE PATH "LOG4CXX header directory" FORCE)
    
    IF(NOT LOG4CXX_FIND_QUIETLY)
        MESSAGE(STATUS "Found LOG4CXX: ${LOG4CXX_LIBRARIES}")
    ENDIF(NOT LOG4CXX_FIND_QUIETLY)
ELSE()
    SET(LOG4CXX_FOUND 0 CACHE BOOL "LOG4CXX not found")
    IF(LOG4CXX_FIND_REQUIRED)
        MESSAGE(FATAL_ERROR "Could NOT find LOG4CXX, error")
    ELSE()
        MESSAGE(STATUS "Could NOT find LOG4CXX, disabled")
    ENDIF()
ENDIF()

MARK_AS_ADVANCED(LOG4CXX_INCLUDE_DIR LOG4CXX_LIBRARIES)

