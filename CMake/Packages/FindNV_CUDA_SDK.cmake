# - Try to find the NV_CUDA_SDK libraries
# Once done this will define
#
# NV_CUDA_SDK_FOUND - system has NV_CUDA_SDK
# NV_CUDA_SDK_BASE_DIR - the NV_CUDA_SDK include directory

IF(NOT WIN32)
    FIND_PATH(NV_CUDA_SDK_BASE_DIR deviceQuery.cpp HINTS
        $ENV{HOME}/
        /usr/local/cuda/
        PATH_SUFFIXES
        "NVIDIA_GPU_Computing_SDK/C/src/deviceQuery"
        "NV_CUDA_SDK/C/src/deviceQuery" # next best guess
        )
    STRING(REGEX REPLACE "src/deviceQuery" "" NV_CUDA_SDK_BASE_DIR ${NV_CUDA_SDK_BASE_DIR})
    SET(NV_CUDA_SDK_BASE_DIR ${NV_CUDA_SDK_BASE_DIR} CACHE PATH "NV_CUDA_SDK base directory" FORCE) # cache result
ENDIF()

IF(NV_CUDA_SDK_BASE_DIR)
    SET(NV_CUDA_SDK_FOUND 1)
    IF(NOT NV_CUDA_SDK_FOUND_QUIETLY)
        MESSAGE(STATUS "Found NV_CUDA_SDK: base = ${NV_CUDA_SDK_BASE_DIR}")
    ENDIF()
ELSE()
    SET(NV_CUDA_SDK_FOUND 0 CACHE BOOL "NV_CUDA_SDK not found")
    MESSAGE(STATUS "NV_CUDA_SDK not found, disabled")
ENDIF()

MARK_AS_ADVANCED(NV_CUDA_SDK_BASE_DIR)
