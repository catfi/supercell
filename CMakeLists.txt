#
# Zillians MMO
# Copyright (C) 2007-2010 Zillians.com, Inc.
# For more information see http://www.zillians.com
#
# Zillians MMO is the library and runtime for massive multiplayer online game
# development in utility computing model, which runs as a service for every
# developer to build their virtual world running on our GPU-assisted machines
#
# This is a close source library intended to be used solely within Zillians.com
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# COPYRIGHT HOLDER(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
# AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# Contact Information: info@zillians.com
#

INCLUDE(icecc.cmake)
CMAKE_MINIMUM_REQUIRED(VERSION 2.6.3)

PROJECT(zillians)

SET(CMAKE_MODULE_PATH
	"${CMAKE_SOURCE_DIR}/CMake"
	"${CMAKE_SOURCE_DIR}/CMake/Packages"
	)

# define global script repository, we should place all helper shell script under this folder
SET(ZILLIANS_SCRIPT_PATH "${CMAKE_SOURCE_DIR}/scripts")

# define global dependency repository
SET(ZILLIANS_DEP_PATH "${CMAKE_SOURCE_DIR}/dep")

SET(__location_ZILLIANS_CAP_VERSION_TOOL "${ZILLIANS_DEP_PATH}/linux/zillians-gpu-hardware-cap/zillians-gpu-hardware-cap")
SET(__location_ZILLIANS_CRYPTO_TOOL "${ZILLIANS_DEP_PATH}/linux/zillians-crypto/zillians-crypto")

IF(CMAKE_SIZEOF_VOID_P EQUAL 8)
    #LIST(APPEND COMPILE_DEFINITIONS "PLATFORM_BIT_WIDTH=64")
    ADD_DEFINITIONS(-DPLATFORM_BIT_WIDTH=64)
ELSE()
    #LIST(APPEND COMPILE_DEFINITIONS "PLATFORM_BIT_WIDTH=32")
    ADD_DEFINITIONS(-DPLATFORM_BIT_WIDTH=32)
ENDIF()

# llvm enable
SET(ENABLE_FEATURE_LLVM TRUE CACHE BOOL "Enable LLVM feature")

#SET(CUDA_ISA_VERSION "2.0" CACHE STRING "PTX ISA Version")

SET(TBB_VERSION "tbb30" CACHE STRING "TBB library version")

# ENABLE/DISABLE C++0x Feature
IF(WIN32)
    SET(ENABLE_FEATURE_CXX_0X FALSE CACHE BOOL "Disable C++0x features")
ELSE()
    SET(ENABLE_FEATURE_CXX_0X TRUE CACHE BOOL "Enable C++0x features")
ENDIF()

# ENABLE/DISABLE TBB
IF(WIN32)
    SET(ENABLE_FEATURE_TBB FALSE CACHE BOOL "Disable building TBB files")
ELSE()
    SET(ENABLE_FEATURE_TBB TRUE CACHE BOOL "Enable building TBB files")
ENDIF()

# ENABLE/DISABLE CUDA
IF(WIN32)
    SET(ENABLE_FEATURE_CUDA FALSE CACHE BOOL "Disable building CUDA files")
ELSE()
    SET(ENABLE_FEATURE_CUDA TRUE CACHE BOOL "Enable building CUDA files")
ENDIF()

# ENABLE/DISABLE RDMA
IF(WIN32)
    SET(ENABLE_FEATURE_RDMA FALSE CACHE BOOL "Disable building RDMA files")
ELSE()
    SET(ENABLE_FEATURE_RDMA TRUE CACHE BOOL "Enable building RDMA files")
ENDIF()

# ENABLE/DISABLE TinyXML++
IF(WIN32)
    SET(ENABLE_FEATURE_TICPP FALSE CACHE BOOL "Disable building TinyXML++ files")
ELSE()
    SET(ENABLE_FEATURE_TICPP TRUE CACHE BOOL "Enable building TinyXML++ files")
ENDIF()

# ENABLE/DISABLE Corosync
IF(WIN32)
    SET(ENABLE_FEATURE_COROSYNC FALSE CACHE BOOL "Disable building Corosync files")
ELSE()
    SET(ENABLE_FEATURE_COROSYNC TRUE CACHE BOOL "Enable building Corosync files")
ENDIF()

# ENABLE/DISABLE RDMA
IF(WIN32)
    SET(ENABLE_FEATURE_RABBITMQ FALSE CACHE BOOL "Disable building RabbitMQ files")
ELSE()
    SET(ENABLE_FEATURE_RABBITMQ TRUE CACHE BOOL "Enable building RabbitMQ files")
ENDIF()

# DISABLE emulation mode by default
SET(ENABLE_FEATURE_EMULATION FALSE CACHE BOOL "Enable emulation mode")

# DISABLE dummy auth mode by default
SET(ENABLE_FEATURE_DUMMY_AUTH FALSE CACHE BOOL "Enable dummy auth mode")

# DISABLE dummy database mode by default
SET(ENABLE_FEATURE_DUMMY_DATABASE FALSE CACHE BOOL "Enable dummy database mode")

# ENABLE garbage collection by default
SET(ENABLE_FEATURE_GARBAGE_COLLECTION TRUE CACHE BOOL "Enable garbage collection")

# DISABLE garbage collection testing by default
SET(ENABLE_FEATURE_GARBAGE_COLLECTION_SELF_TEST FALSE CACHE BOOL "Enable garbage collection self testing")

# ENABLE Cuda Daemon process by default
SET(ENABLE_FEATURE_VGPU_CUDA_DAEMON_PROCESS TRUE CACHE BOOL "Enable cuda daemon process spawn for per vgpu client")

# ENABLE/DISABLE virtualization GPU project debug message
SET(ENABLE_FEATURE_VGPU_DEBUG_MESSAGE TRUE CACHE BOOL "Enable virtualization GPU project debug message")

# ENABLE/DISABLE virtualization GPU project dump message
SET(ENABLE_FEATURE_VGPU_DUMP_MESSAGE FALSE CACHE BOOL "Enable virtualization GPU project message dumping instead of displaying")

# ENABLE/DISABLE virtualization GPU project anti-debug
SET(ENABLE_FEATURE_VGPU_ANTI_DEBUG FALSE CACHE BOOL "Enable virtualization GPU project anti-debugging")

# ENABLE/DISABLE cuda thrust specialization build 
IF(WIN32)
    SET(ENABLE_FEATURE_THRUST_SPECIALIZATION FALSE CACHE BOOL "Disable building thrust specialization")
ELSE()
    SET(ENABLE_FEATURE_THRUST_SPECIALIZATION FALSE CACHE BOOL "Enable building thrust specialization")
ENDIF()

SET(ADDITIONAL_CXX_FLAGS_LIST "-Wno-deprecated -fPIC")

# Ensure that standard library is set to compatible with multi-thread code
ADD_DEFINITIONS(-D_REENTRANT)

IF(ENABLE_FEATURE_CXX_0X)
	IF(NOT WIN32)
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated -fpermissive -fPIC -std=c++0x")
		ADD_DEFINITIONS(-DENABLE_CXX_0X_FEATURE)
	ELSE()
	ENDIF()
ELSE()
	IF(NOT WIN32)
	    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated -fPIC")
	    ADD_DEFINITIONS(-DENABLE_CXX_0X_FEATURE)
	ELSE()
	ENDIF()
ENDIF()

IF(ENABLE_FEATURE_EMULATION)
    ADD_DEFINITIONS(-DENABLE_EMULATION_MODE)
ENDIF()

IF(ENABLE_FEATURE_DUMMY_AUTH)
    ADD_DEFINITIONS(-DENABLE_DUMMY_AUTH_MODE)
ENDIF(ENABLE_FEATURE_DUMMY_AUTH)

IF(ENABLE_FEATURE_DUMMY_DATABASE)
    ADD_DEFINITIONS(-DENABLE_DUMMY_DATABASE_MODE)
ENDIF(ENABLE_FEATURE_DUMMY_DATABASE)

IF(ENABLE_FEATURE_GARBAGE_COLLECTION)
	ADD_DEFINITIONS(-DENABLE_GARBAGE_COLLECTION)
ENDIF(ENABLE_FEATURE_GARBAGE_COLLECTION)

IF(ENABLE_FEATURE_GARBAGE_COLLECTION_SELF_TEST)
	ADD_DEFINITIONS(-DENABLE_GARBAGE_COLLECTION_SELF_TEST)
ENDIF(ENABLE_FEATURE_GARBAGE_COLLECTION_SELF_TEST)

IF(ENABLE_FEATURE_VGPU_CUDA_DAEMON_PROCESS)
	ADD_DEFINITIONS(-DENABLE_VGPU_CUDA_DAEMON_PROCESS)
ENDIF(ENABLE_FEATURE_VGPU_CUDA_DAEMON_PROCESS)

IF(ENABLE_FEATURE_VGPU_DEBUG_MESSAGE)
	ADD_DEFINITIONS(-DENABLE_VGPU_DEBUG_MESSAGE)
ENDIF(ENABLE_FEATURE_VGPU_DEBUG_MESSAGE)


IF(ENABLE_FEATURE_VGPU_DUMP_MESSAGE)
	ADD_DEFINITIONS(-DENABLE_VGPU_DUMP_MESSAGE)
ENDIF(ENABLE_FEATURE_VGPU_DUMP_MESSAGE)

IF(ENABLE_FEATURE_VGPU_ANTI_DEBUG)
	ADD_DEFINITIONS(-DENABLE_VGPU_ANTI_DEBUGGING)
ENDIF(ENABLE_FEATURE_VGPU_ANTI_DEBUG)  

SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")

IF(NOT WIN32)
	SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
ENDIF()

# ENABLE/DISABLE Just Thread
IF(WIN32)
    SET(ENABLE_FEATURE_JUSTTHREAD TRUE CACHE BOOL "Disable building Just Thread (C++0x threading) files")
ELSE()
    SET(ENABLE_FEATURE_JUSTTHREAD TRUE CACHE BOOL "Enable building Just Thread (C++0x threading) files")
ENDIF()

# set default compilation type
SET(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Build Type")

# the default compilation type for CUDA code
SET(CUDA_BUILD_TYPE "Device")

# enable CMake built-in testing function
add_custom_target(check)

ENABLE_TESTING()
INCLUDE(Dart)

INCLUDE(Dependencies)

# define CUDA-related constants by either probing or user-defined value
IF(ENABLE_FEATURE_CUDA)
    MESSAGE(STATUS "CUDA Toolkit Version = ${CUDA_VERSION}")
    IF(CUDA_VERSION VERSION_GREATER "3.1")
        # for CUDA toolkit 3.1 and later, the GPU memory pointer is changed to 64-bit
        ADD_DEFINITIONS(-DENABLE_CUDA_POINTER_64BIT)
        
        # check to see if the CUDA_SM_VERSION is properly defined
        IF(NOT (CUDA_SM_VERSION MATCHES "sm_([0-9])([0-9])"))
            EXECUTE_PROCESS(
                COMMAND ${__location_ZILLIANS_CAP_VERSION_TOOL} --sm_version
                RESULT_VARIABLE result
                OUTPUT_VARIABLE temp
                )
            if(${result} EQUAL 0)
	            message(STATUS "CUDA SM version is not specified, probed and set to ${temp}")
	            SET(CUDA_SM_VERSION ${temp} CACHE STRING "CUDA SM compilation target" FORCE)
            else()
            	message(STATUS "CUDA SM version is not specified and failed to probe CUDA device, setting default CUDA SM version = sm_20")
            	SET(CUDA_SM_VERSION "sm_20" CACHE STRING "CUDA SM compilation target" FORCE)
            endif()
	        MARK_AS_ADVANCED(CUDA_SM_VERSION)
        ELSE()
            MESSAGE(STATUS "CUDA SM Version = ${CUDA_SM_VERSION}")
        ENDIF()
        
        # check to see if the CUDA_ISA_VERSION is properly defined 
        IF(NOT (CUDA_ISA_VERSION MATCHES "([0-9]+)\\.([0-9]+)"))
            EXECUTE_PROCESS(
                COMMAND ${__location_ZILLIANS_CAP_VERSION_TOOL} --isa_version
                RESULT_VARIABLE result
                OUTPUT_VARIABLE temp
                )
            if(${result} EQUAL 0)
	            message(STATUS "CUDA PTX ISA version is not specified, probed and set to ${temp}")
	            SET(CUDA_ISA_VERSION ${temp} CACHE STRING "CUDA PTX ISA target" FORCE)
            else()
	            message(STATUS "CUDA PTX ISA version is not specified and failed to probe CUDA device, setting default CUDA PTX ISA version to 2.2")
    	        SET(CUDA_ISA_VERSION "2.2" CACHE STRING "CUDA PTX ISA target" FORCE)
            endif()
            MARK_AS_ADVANCED(CUDA_ISA_VERSION)
        ELSE()
            MESSAGE(STATUS "CUDA PTX ISA Version = ${CUDA_ISA_VERSION}")
        ENDIF()
        
        # check if we can enable new features in Fermi GPU
        IF(CUDA_SM_VERSION MATCHES "sm_2([0-9])" AND CUDA_VERSION VERSION_GREATER "3.1")
            MESSAGE(STATUS "Enable Fermi GPU Features")
            SET(CUDA_ENABLE_KERNEL_MALLOC TRUE)
        ELSE()
            MESSAGE(STATUS "Disable Fermi GPU Features")
            SET(CUDA_ENABLE_KERNEL_MALLOC FALSE)
        ENDIF()
    ELSE()
        # we only support CUDA 3.2 or later (the cutting-edge CUDA release)
        MESSAGE(FATAL_ERROR "Please upgrade CUDA toolkit to 3.2 or later")
    ENDIF()
ENDIF()

# set default executable path
SET(EXECUTABLE_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/bin CACHE PATH "Default executable path" FORCE)
SET(LIBRARY_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/lib  CACHE PATH "Default library path" FORCE)

# base64 library contributed by Chris Venter
#ADD_SUBDIRECTORY(dep/base64)

# custom build version of OFED stack
IF(NOT WIN32)
#   ADD_SUBDIRECTORY(dep/linux/ofed/)
	if( THRIFT_FOUND )
		ADD_SUBDIRECTORY(dep/linux/cassandra/)
	ENDIF( THRIFT_FOUND )
ENDIF()

# thrust specialization build
IF(ENABLE_FEATURE_THRUST_SPECIALIZATION)
	ADD_SUBDIRECTORY(dep/linux/thrust)
ENDIF()

# automatically generate documentation
SET(DEFAULT_DOCUMENT_PATH ${CMAKE_CURRENT_BINARY_DIR}/docs)

# for cloude default machine
SET( ZILLIANS_DB_SERVER	"g3" CACHE STRING "Zillians's default Database Server Address")
SET( ZILLIANS_MANAGEMENT_PORT "9090" CACHE STRING "Zillians's default Management Server Port")
SET( ZILLIANS_HOME	"${CMAKE_SOURCE_DIR}" CACHE STRING "ZilliansHome - $ZILLIANS_HOME ")
SET( ZILLIANS_INC	"${CMAKE_SOURCE_DIR}/inc/" CACHE STRING "ZilliansHome - $ZILLIANS_HOME ")
SET( ZCC    "${CMAKE_SOURCE_DIR}/bin/zcc" CACHE STRING "ZCC Specific ")
SET( ZCC_GW "${CMAKE_SOURCE_DIR}/bin/zcc" CACHE STRING "ZCC_GW Specific ") 
SET( ZCC_WS "${CMAKE_SOURCE_DIR}/bin/zcc" CACHE STRING "ZCC_WS Specific ")
SET( ZCC_BC "${CMAKE_SOURCE_DIR}/bin/zcc-bc" CACHE STRING "ZCC_BC Specific ") 
SET( ZILLIANS_LLC   "${CMAKE_SOURCE_DIR}/bin/zillians-llc" CACHE STRING "zillians llc specific ")
SET( ZILLIANS_LD    "${CMAKE_SOURCE_DIR}/bin/zillians-ld" CACHE STRING "zillians ld specific ")
SET( ZCC_STUB_DISPATCH "${CMAKE_SOURCE_DIR}/bin/zillians-stub-gen" CACHE STRING "ZCC_STUB_DISPATCH Specific ")
SET( COG_TOOL "cog.py" CACHE STRING "Python Cog Specific ")

SET( ZCC_LIT_TEST_REPEAT "1" CACHE STRING "Zcc+Lit Test suite repleat time")
SET( LIT_OPTIONS	-v --shuffle)

ADD_SUBDIRECTORY(projects)
#ADD_SUBDIRECTORY(packages)
