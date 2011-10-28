# - Try to find the THORPP script
# Once done this will define
#
# THORPP_PROGRAM - system has THORPP

IF(NOT WIN32)
    FIND_PROGRAM(THORPP_PROGRAM "thorpp" PATHS
        /usr/local/bin
        )
ENDIF()

IF(THORPP_PROGRAM)
    SET(THORPP_FOUND 1)
    IF(NOT THORPP_FOUND_QUIETLY)
        MESSAGE(STATUS "Found ThorPP: program = ${THORPP_PROGRAM}")
    ENDIF()
ELSE()
    SET(THORPP_FOUND 0 CACHE BOOL "ThorPP not found")
    MESSAGE(STATUS "ThorPP not found, disabled")
ENDIF()

MARK_AS_ADVANCED(THORPP_PROGRAM)
