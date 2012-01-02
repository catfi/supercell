# - Try to find the Thrift libraries
# Once done this will define
#
# THRIFT_FOUND - system has Thrift
# THRIFT_INCLUDE_DIR - the Thrift include directory
# THRIFT_LIBRARIES - Thrift library

IF(NOT WIN32)
    FIND_PATH(THRIFT_INCLUDE_DIR Thrift.h PATHS
        /usr/include/thrift
        /usr/local/include/thrift
        )

#    FIND_LIBRARY(THRIFT_LIBRARIES_FPIC NAMES thrift HINTS
#        ${CMAKE_SOURCE_DIR}/dep/linux/thrift/lib
#        )

    #FIND_PATH(THRIFT_LIBRARIES NAMES thrift.so HINTS
     #   /usr/lib64
      
      #  /usr/lib
       # )
    FIND_PATH(THRIFT_LIBRARIES libthrift.so PATHS /usr/lib /usr/local/lib)
    MESSAGE(STATUS THRIFT_LIBRARYS=${THRIFT_LIBRARIES} )
    IF( THRIFT_LIBRARIES )
      SET( THRIFT_LIBRARIES ${THRIFT_LIBRARIES}/libthrift.so )
    ELSE()
    	FIND_PATH(THRIFT_LIBRARIES libthrift.so.0 PATHS /usr/lib64 /usr/lib /usr/local/lib)
	IF( THRIFT_LIBRARIES )
      		SET( THRIFT_LIBRARIES ${THRIFT_LIBRARIES}/libthrift.so.0 )
	ENDIF()
    ENDIF()
        
    FIND_PROGRAM(THRIFT_COMPILER thrift 
        /usr/bin
        /usr/local/bin
        )
        
ENDIF()

#IF(THRIFT_INCLUDE_DIR AND THRIFT_LIBRARIES AND THRIFT_LIBRARIES_FPIC AND THRIFT_COMPILER)
IF(THRIFT_INCLUDE_DIR AND THRIFT_LIBRARIES AND THRIFT_COMPILER)
    SET(THRIFT_FOUND 1)
    IF(NOT THRIFT_FOUND_QUIETLY)
        MESSAGE(STATUS "Found THRIFT: include = ${THRIFT_INCLUDE_DIR}, libraries = ${THRIFT_LIBRARIES}, fpic libraries = ${THRIFT_LIBRARIES_FPIC}, thrift_compiler ${THRIFT_COMPILER}")
    ENDIF()
ELSE()
    SET(THRIFT_FOUND 0 CACHE BOOL "THRIFT not found")
    MESSAGE(STATUS "THRIFT not found, disabled")
ENDIF()

MARK_AS_ADVANCED(THRIFT_INCLUDE_DIR THRIFT_LIBRARIES)

MESSAGE(" thrift header - ${THRIFT_INCLUDE_DIR} ")
