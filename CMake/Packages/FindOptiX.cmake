# - Try to find the OptiX libraries
# Once done this will define
#
# OPTIX_FOUND - system has OptiX
# OPTIX_INCLUDE_DIR - the OptiX include directory
# OPTIX_LIBRARIES   - the OptiX libraries

MESSAGE(STATUS "Looking for OptiX...")

FIND_PATH(OPTIX_INCLUDE_DIR optix_cuda.h PATHS 
	/usr/include/ 
	/usr/local/include/
	${CUDA_INCLUDE_DIRS}
	${CMAKE_SOURCE_DIR}/dep/linux/optix/include/
	)

IF(CMAKE_SIZEOF_VOID_P EQUAL 8)
    FIND_LIBRARY(OPTIX_LIBRARIES_OPTIX NAMES optix PATHS
        ${CMAKE_SOURCE_DIR}/dep/linux/optix/lib64/
        )
    FIND_LIBRARY(OPTIX_LIBRARIES_OPTIXU NAMES optixu PATHS
        ${CMAKE_SOURCE_DIR}/dep/linux/optix/lib64/
        )
ELSE()
    FIND_LIBRARY(OPTIX_LIBRARIES_OPTIX NAMES optix PATHS
        ${CMAKE_SOURCE_DIR}/dep/linux/optix/lib/
        )
    FIND_LIBRARY(OPTIX_LIBRARIES_OPTIXU NAMES optixu PATHS
        ${CMAKE_SOURCE_DIR}/dep/linux/optix/lib/
        )
ENDIF()
	
IF(OPTIX_INCLUDE_DIR AND OPTIX_LIBRARIES_OPTIX AND OPTIX_LIBRARIES_OPTIXU)
	SET(OPTIX_FOUND 1)
	SET(OPTIX_LIBRARIES ${OPTIX_LIBRARIES_OPTIX} ${OPTIX_LIBRARIES_OPTIXU})
	IF(NOT OPTIX_FIND_QUIETLY)
		MESSAGE(STATUS "Found OptiX: include dir = ${OPTIX_INCLUDE_DIR}, libraries = ${OPTIX_LIBRARIES}")
	ENDIF()
ELSE()
	SET(OPTIX_FOUND 0 CACHE BOOL "OptiX not found")
	IF(OPTIX_FIND_REQUIRED)
    	MESSAGE(FATAL_ERROR "Could NOT find OptiX, error")
	ELSE()
		MESSAGE(STATUS "Could NOT find OptiX, disabled")
	ENDIF()
ENDIF()

MARK_AS_ADVANCED(OPTIX_INCLUDE_DIR)
MARK_AS_ADVANCED(OPTIX_LIBRARIES)

