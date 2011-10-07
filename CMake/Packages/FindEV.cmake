# - Try to find the LibEv libraries
# Once done this will define
#
# EV_FOUND - system has liblog4cxx
# EV_INCLUDE_DIR - the liblog4cxx include directory
# EV_LIBRARIES - liblog4cxx library

MESSAGE(STATUS "Looking for EV...")

FIND_PATH(EV_INCLUDE_DIR ev.h PATHS 
	/usr/include/ 
	/usr/local/include/ 
	/usr/local/include/ev/ 
	)
	
FIND_LIBRARY(EV_LIBRARIES NAMES ev)

IF(EV_INCLUDE_DIR AND EV_LIBRARIES)
    SET(EV_FOUND 1)
    IF(NOT EV_FIND_QUIETLY)
        MESSAGE(STATUS "Found EV: libraries = ${EV_LIBRARIES}")
    ENDIF(NOT EV_FIND_QUIETLY)
ELSE(EV_INCLUDE_DIR AND EV_LIBRARIES)
    SET(EV_FOUND 0 CACHE BOOL "EV not found")
    MESSAGE(STATUS "Could NOT find EV, disabled")
ENDIF(EV_INCLUDE_DIR AND EV_LIBRARIES)

MARK_AS_ADVANCED(EV_INCLUDE_DIR EV_LIBRARIES)

