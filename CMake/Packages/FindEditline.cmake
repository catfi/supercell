# - Try to find the editline libraries
# Once done this will define
#
# EDITLINE_FOUND - system has editline
# EDITLINE_INCLUDE_DIR - the editline include directory
# EDITLINE_LIBRARY - editline library
#
# Zac: if editline not found, please make sure you have installed the package: libedit-dev
#   $ sudo apt-get install libedit-dev
#

FIND_PATH(EDITLINE_INCLUDE_DIR editline/readline.h)
FIND_LIBRARY(EDITLINE_LIBRARY NAMES edit) 

IF (EDITLINE_INCLUDE_DIR AND EDITLINE_LIBRARY)
   SET(EDITLINE_FOUND TRUE)
ENDIF (EDITLINE_INCLUDE_DIR AND EDITLINE_LIBRARY)

IF (EDITLINE_FOUND)
   IF (NOT EDITLINE_FIND_QUIETLY)
      MESSAGE(STATUS "Found editline: include = ${EDITLINE_INCLUDE_DIR}, libraries = ${EDITLINE_LIBRARY}")
   ENDIF (NOT EDITLINE_FIND_QUIETLY)
ELSE (EDITLINE_FOUND)
   MESSAGE(STATUS "editline not found, disabled")
   IF (EDITLINE_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "Could not find editline")
   ENDIF (EDITLINE_FIND_REQUIRED)
ENDIF (EDITLINE_FOUND)
