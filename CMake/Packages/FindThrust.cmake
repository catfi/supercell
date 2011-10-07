# - Try to find the Thrust libraries
# Once done this will define
#
# THRUST_FOUND - system has THRUST
# THRUST_INCLUDE_DIR - the THRUST include directory

UNSET(THRUST_INCLUDE_DIR CACHE)
UNSET(THRUST_LIBRARIES CACHE)

FIND_PATH(THRUST_INCLUDE_DIR thrust/device_vector.h PATHS 
	/usr/include/ 
	/usr/local/include/
	${CUDA_INCLUDE_DIRS}
	)
	
IF(THRUST_INCLUDE_DIR)
    STRING(REGEX REPLACE "/thrust$" "" THRUST_INCLUDE_DIR_SUP ${THRUST_INCLUDE_DIR})
    SET(THRUST_INCLUDE_DIR ${THRUST_INCLUDE_DIR_SUP} CACHE PATH "thrust header directory" FORCE)
    
	SET(THRUST_INCLUDE_FOUND 1)
	IF(NOT THRUST_FIND_QUIETLY)
		MESSAGE(STATUS "Found thrust: include dir = ${THRUST_INCLUDE_DIR}")
	ENDIF(NOT THRUST_FIND_QUIETLY)
ELSE()
	SET(THRUST_INCLUDE_FOUND 0 CACHE BOOL "thrust not found")
	IF(THRUST_FIND_REQUIRED)
	    MESSAGE(FATAL_ERROR "Could NOT find thrust, error")
	ELSE()
	    MESSAGE(STATUS "Could NOT find thrust")
	ENDIF()
ENDIF()

IF(NOT ENABLE_FEATURE_THRUST_SPECIALIZATION)
    FIND_LIBRARY(THRUST_LIBRARIES NAMES thrust-specialization-impl PATHS
        ${CMAKE_CURRENT_SOURCE_DIR}/dep/linux/thrust/lib64
        /usr/lib
        )
    IF(THRUST_LIBRARIES)
        SET(THRUST_LIBRARIES_FOUND 1)
        IF(NOT THRUST_FIND_QUIETLY)
	        MESSAGE(STATUS "Found thrust specialization: lib = ${THRUST_LIBRARIES}")
        ENDIF(NOT THRUST_FIND_QUIETLY)
    ELSE()
        SET(THRUST_LIBRARIES_FOUND 0)
        IF(THRUST_FIND_REQUIRED)
            MESSAGE(FATAL_ERROR "Could NOT find thrust specialization library, error")
        ELSE()
            MESSAGE(STATUS "Could NOT find thrust specialization library")
        ENDIF()
    ENDIF()
ELSE()
    IF(NOT THRUST_FIND_QUIETLY)
        MESSAGE(STATUS "Found thrust specialization: custom build")
    ENDIF(NOT THRUST_FIND_QUIETLY)
    SET(THRUST_LIBRARIES "thrust-specialization-impl" CACHE STRING "thrust specialization dependecies" FORCE)
    SET(THRUST_LIBRARIES_FOUND 1)
ENDIF()

IF(THRUST_INCLUDE_FOUND AND THRUST_LIBRARIES_FOUND)
    SET(THRUST_FOUND 1)
ELSE()
    SET(THRUST_FOUND 0)
ENDIF()

MARK_AS_ADVANCED(THRUST_INCLUDE_DIR THRUST_LIBRARIES)

