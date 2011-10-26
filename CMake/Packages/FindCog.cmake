# - Try to find the COG script
# Once done this will define
#
# COG_SCRIPT - system has COG

IF(NOT WIN32)
    FIND_PROGRAM(COG_SCRIPT "cog.py" PATHS
        /usr/local/bin
        )
ENDIF()

IF(COG_SCRIPT)
    SET(COG_FOUND 1)
    IF(NOT COG_FOUND_QUIETLY)
        MESSAGE(STATUS "Found COG: script = ${COG_SCRIPT}")
    ENDIF()
ELSE()
    SET(COG_FOUND 0 CACHE BOOL "COG not found")
    MESSAGE(STATUS "COG not found, disabled")
ENDIF()

MARK_AS_ADVANCED(COG_SCRIPT)
