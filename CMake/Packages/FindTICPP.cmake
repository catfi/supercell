# - Try to find the TICPP libraries
# Once done this will define
#
# TICPP_FOUND - system has TinyXML++
# TICPP_INCLUDE_DIR - the TinyXML++ include directory
# TICPP_LIBRARIES - TinyXML++ library

MESSAGE(STATUS "Looking for TICPP...")

IF(WIN32)
    FIND_PATH(TICPP_INCLUDE_DIR ticpp.h PATHS 
    	/usr/include/ 
    	/usr/local/include/
    	${CMAKE_SOURCE_DIR}/dep/windows/ticpp/include/
    	PATH_SUFFIXES "ticpp"
    	)
    FIND_LIBRARY(TICPP_LIBRARIES NAMES ticpp PATHS
        ${CMAKE_SOURCE_DIR}/dep/windows/ticpp/lib/
        )
ELSE()
    FIND_PATH(TICPP_INCLUDE_DIR ticpp.h PATHS 
    	/usr/include/ 
    	/usr/local/include/
    	${CMAKE_SOURCE_DIR}/dep/linux/ticpp/include/ 
    	PATH_SUFFIXES "ticpp"
    	)
    FIND_LIBRARY(TICPP_LIBRARIES NAMES ticpp PATHS
        ${CMAKE_SOURCE_DIR}/dep/linux/ticpp/lib/
        )
ENDIF()

IF(TICPP_INCLUDE_DIR AND TICPP_LIBRARIES)
	SET(TICPP_FOUND 1)
	
    STRING(REGEX REPLACE "/ticpp$" "" TICPP_INCLUDE_DIR_SUP ${TICPP_INCLUDE_DIR})
    SET(TICPP_INCLUDE_DIR ${TICPP_INCLUDE_DIR_SUP} CACHE PATH "TICPP header directory" FORCE)
	
	IF(NOT TICPP_FIND_QUIETLY)
		MESSAGE(STATUS "Found TICPP: ${TICPP_LIBRARIES}")
	ENDIF(NOT TICPP_FIND_QUIETLY)
ELSE(TICPP_INCLUDE_DIR AND TICPP_LIBRARIES)
	SET(TICPP_FOUND 0 CACHE BOOL "TICPP not found")
    IF(TICPP_FIND_REQUIRED)
        MESSAGE(FATAL_ERROR "TICPP not found, error")
    ELSE()
        MESSAGE(STATUS "TICPP not found, disabled")
    ENDIF()
ENDIF(TICPP_INCLUDE_DIR AND TICPP_LIBRARIES)

MARK_AS_ADVANCED(TICPP_INCLUDE_DIR TICPP_LIBRARIES)

