# - Try to find the LibConfig libraries
# Once done this will define
#
# LIBCONFIG_FOUND - system has Config
# LIBCONFIG_INCLUDE_DIR - the Config include directory
# LIBCONFIG_LIBRARIES - Config library

IF(NOT WIN32)
    FIND_PATH(LIBCONFIG_INCLUDE_DIR libconfig.h++ PATHS
        /usr/include/
        )

    FIND_PATH(LIBCONFIG_LIBRARIES libconfig++.so 
        /usr/lib
	/usr/lib64
        )
    
    IF( LIBCONFIG_LIBRARIES )
        SET( LIBCONFIG_LIBRARIES ${LIBCONFIG_LIBRARIES}/libconfig++.so )
    ENDIF()
        
#    FIND_PROGRAM(LIBCONFIG_COMPILER thrift 
#        /usr/bin
#        /usr/local/bin
#        )
ENDIF()

IF(LIBCONFIG_INCLUDE_DIR AND LIBCONFIG_LIBRARIES)
    SET(LIBCONFIG_FOUND 1)
    IF(NOT LIBCONFIG_FOUND_QUIETLY)
        MESSAGE(STATUS "Found Libconfig: include = ${LIBCONFIG_INCLUDE_DIR}, libraries = ${LIBCONFIG_LIBRARIES}")
    ENDIF()
ELSE()
    SET(LIBCONFIG_FOUND 0 CACHE BOOL "LIBCONFIG not found")
    MESSAGE(STATUS "LIBCONFIG not found, disabled")
ENDIF()

MARK_AS_ADVANCED(LIBCONFIG_INCLUDE_DIR LIBCONFIG_LIBRARIES)
