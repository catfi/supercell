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

# include custom macros
include(CMakeParseArguments)

include(ZilliansCommonUtility)
include(ZilliansBufferGeneratorUtility)
include(ZilliansHashmapUtility)
include(ZilliansOptionUtility)
include(ZilliansTestUtility)
#include(ZilliansCopyUtility)
include(ZilliansPtxUtility)
include(UsingGameNameTable)
include(PCHSupport)

include(ZilliansCompilerUtility)

zillians_register_game(GAME_NAME "AtTargetTestClient"                         GAME_ID 0)
zillians_register_game(GAME_NAME "AtTargetTestClient_qt4"                     GAME_ID 0)
zillians_register_game(GAME_NAME "BandwidthStressTest"                        GAME_ID 0)
zillians_register_game(GAME_NAME "ConnectionStressTest"                       GAME_ID 0)
zillians_register_game(GAME_NAME "DatabaseTestClient_AllTypesTest"            GAME_ID 0)
zillians_register_game(GAME_NAME "DBTestClient_DemoClientV2"                  GAME_ID 2)
zillians_register_game(GAME_NAME "DatabaseTestClient_Qt4Canvas"               GAME_ID 0)
zillians_register_game(GAME_NAME "DemoBotClient"                              GAME_ID 0)
zillians_register_game(GAME_NAME "DemoClientV2"                               GAME_ID 0)
zillians_register_game(GAME_NAME "DemoClientV2AI"                             GAME_ID 1)
zillians_register_game(GAME_NAME "DemoGodView"                                GAME_ID 1)
zillians_register_game(GAME_NAME "Grid2dStressTest"                           GAME_ID 0)
zillians_register_game(GAME_NAME "KNN2dStressTest"                            GAME_ID 0)
zillians_register_game(GAME_NAME "Qt4Canvas_cli"                              GAME_ID 0)
zillians_register_game(GAME_NAME "Qt4Rogue_cli"                               GAME_ID 0)
zillians_register_game(GAME_NAME "SimpleQT4TestClient"                        GAME_ID 0)
zillians_register_game(GAME_NAME "SimpleSessionOpenCloseTestClient"           GAME_ID 0)
zillians_register_game(GAME_NAME "SimpleTestClient"                           GAME_ID 0)
zillians_register_game(GAME_NAME "SOHProject"                                 GAME_ID 0)
zillians_register_game(GAME_NAME "SOHProject_Template"                        GAME_ID 0)
zillians_register_game(GAME_NAME "testzillians_emulator_ConnectionTestClient" GAME_ID 106)
zillians_register_game(GAME_NAME "TexasHoldem"                                GAME_ID 0)
zillians_register_game(GAME_NAME "tutorial_1"                                 GAME_ID 0)
zillians_register_game(GAME_NAME "tutorial_2"                                 GAME_ID 0)
zillians_register_game(GAME_NAME "tutorial_3"                                 GAME_ID 0)
zillians_register_game(GAME_NAME "tutorial_6"                                 GAME_ID 0)
zillians_register_game(GAME_NAME "tutorial_7"                                 GAME_ID 0)
zillians_register_game(GAME_NAME "tutorial_9"                                 GAME_ID 0)
zillians_register_game(GAME_NAME "tutorial_1_logger"                          GAME_ID 0)
zillians_register_game(GAME_NAME "localTestSOH"                               GAME_ID 0)
zillians_register_game(GAME_NAME "Emu"                                        GAME_ID 0)
zillians_register_game(GAME_NAME "SimpleTextClientTest-SingleCommand"         GAME_ID 0)
zillians_register_game(GAME_NAME "SimpleTest"                                 GAME_ID 0)
zillians_register_game(GAME_NAME "PaperScissorsRock"                          GAME_ID 0)

zillians_register_game(GAME_NAME "ScheduleAPITest"                            GAME_ID 0)

##########################################################################
#  CEGUI_INCLUDE_DIR
#  CEGUI_LIBRARY, the library to link against to use CEGUI.
#  CEGUI_FOUND, If false, do not try to use CEGUI
#  CEGUI_VERSION, the version as string "x.y.z"
#  CEGUILUA_LIBRARY, Script module library
#  CEGUILUA_USE_INTERNAL_LIBRARY, True if CEGUILUA_LIBRARY was not defined here
FIND_PACKAGE(CEGUI)
#  OGRE_INCLUDE_DIR
#  OGRE_LIBRARIES, the libraries to link against to use OGRE.
#  OGRE_LIB_DIR, the location of the libraries
#  OGRE_FOUND, If false, do not try to use OGRE
FIND_PACKAGE(OGRE)
#  OIS_FOUND - system has OIS
#  OIS_INCLUDE_DIRS - the OIS include directories
#  OIS_LIBRARIES - link these to use OIS
#  OIS_BINARY_REL / OIS_BINARY_DBG - DLL names (windows only)
FIND_PACKAGE(OIS)
#  ALUT_LIBRARY
#  ALUT_FOUND, if false, do not try to link to Alut
#  ALUT_INCLUDE_DIR, where to find the headers
FIND_PACKAGE(ALUT)
#  FMODEX_INCLUDE_DIR
#  FMODEX_LIBRARIES
#  FMODEX_FOUND
#FIND_PACKAGE(FMODEX)

##########################################################################
# Find "APR" => "Apache Portable Runtime"
# => APR_INCLUDES		: include directory for apr.h
# => APR_EXTRALIBS		: extra libraries
# => APR_LIBS			: apr libraries
FIND_PACKAGE(APRCore REQUIRED)

##########################################################################
# Find "APRUtil" => "Apache Portable Runtime - Utility"
# => APRUTIL_INCLUDES	: include directory for apr_*.h
# => APRUTIL_LIBS		: library
FIND_PACKAGE(APRUtil REQUIRED)

##########################################################################
# Find "Mongo" => "mongoDB"
# => MONGO_INCLUDES		: include directory for dbclient.h
# => MONGO_LIBRARIES	: Mongo libraries
FIND_PACKAGE(Mongo)

##########################################################################
# Find "Thrift" => "thrift"
# => THRIFT_INCLUDE_DIR		: include directory for Thrift.h
# => THRIFT_LIBRARIES	    : thrift libraries
FIND_PACKAGE(Thrift)

##########################################################################
# Find "Cassandra" => "cassandra"
# => CASSANDRA_INCLUDE_DIR		: include directory for Cassandra.h
# => CASSANDRA_LIBRARIES	    : Cassandra libraries
IF(THRIFT_FOUND)
    FIND_PACKAGE(Cassandra)
ENDIF()

##########################################################################
# Find "ANN" => "ann"
# => ANN_INCLUDE_DIR : include directory for ANN.h
FIND_PACKAGE(ANN)
IF(ANN_FOUND)
    MESSAGE( "-- Found ANN" )
ENDIF()

##########################################################################
# Find "Graphviz" => "Graphviz"
# => GRAPHVIZ_INCLUDE_DIR : include directory for graphviz/graph.h
FIND_PACKAGE(Graphviz)
IF(GRAPHVIZ_FOUND)
    MESSAGE( "-- Found Graphviz" )
ENDIF()

##########################################################################
FIND_PACKAGE(XDot)
IF(XDOT_FOUND)
    MESSAGE( "-- Found XDot" )
ENDIF()

##########################################################################
FIND_PACKAGE(Cog REQUIRED)
IF(COG_FOUND)
    MESSAGE( "-- Found Cog" )
ENDIF()

##########################################################################
FIND_PACKAGE(ThorPP REQUIRED)
IF(THORPP_FOUND)
    MESSAGE( "-- Found ThorPP" )
ENDIF()

##########################################################################
FIND_PACKAGE(BISON)
IF(BISON_FOUND)
    MESSAGE( "-- Found Bison" )
ENDIF()

##########################################################################
FIND_PACKAGE(FLEX)
IF(FLEX_FOUND)
    MESSAGE( "-- Found Flex" )
ENDIF()

##########################################################################
FIND_PACKAGE(TinyXML)
IF(TINYXML_FOUND)
    MESSAGE( "-- Found TinyXML" )
ENDIF()

##########################################################################
# Find "NV_CUDA_SDK" => "CUDA Toolkit"
# => NV_CUDA_SDK_DIR : base directory for deviceQuery.cpp
FIND_PACKAGE(NV_CUDA_SDK)

##########################################################################
# Find "Readline" => "GNU readline"
# => READLINE_INCLUDE_DIR    : include directory for readline.h
# => READLINE_LIBRARY        : readline libraries
FIND_PACKAGE(Readline)

##########################################################################
# Find "Editline" => "Editline"
# => EDITLINE_INCLUDE_DIR    : include directory for editline/readline.h
# => EDITLINE_LIBRARY        : editline libraries
FIND_PACKAGE(Editline)

##########################################################################
# Find "Editline" => "Editline"
# => EDITLINE_INCLUDE_DIR    : include directory for editline/readline.h
# => EDITLINE_LIBRARY        : editline libraries
FIND_PACKAGE(Libconfig)

##########################################################################
# Find "ANTLR3_LIBS" => "ANother Tool for Language Recognition"'s static library
# => ANTLR3_INCLUDE_DIR : include directory for antlr3_*.h
# => ANTLR3_STATIC_LIB_DIR: library
# => ANTLR3_COMMAND
FIND_PACKAGE(Antlr3 REQUIRED)

##########################################################################
IF(ENABLE_FEATURE_LLVM)
	FIND_PACKAGE(LLVM REQUIRED)
ELSE()
	message("-- Disable LLVM related feature ")
ENDIF(ENABLE_FEATURE_LLVM)

##########################################################################
FIND_PACKAGE(ZilliansCompiler REQUIRED)

FIND_PACKAGE(Bullet)

FIND_PACKAGE(XMLRPC)

FIND_PACKAGE(OpenGL)
IF( OPENGL_FOUND )
	message( "-- Found OpenGL" )
ENDIF()

FIND_PACKAGE(GLUT)
IF( GLUT_FOUND )
	message( "-- Found GLUT" )
ENDIF()

FIND_PACKAGE( Qt4 )
IF( QT4_FOUND )
	message( "-- Qt4 Enabled")
	#include(${QT_USE_FILE})
ENDIF()

##########################################################################
# Find "Cuda" => "NVIDIA - Compute Unified Device Architecture"
# => CUDA_INCLUDE			: include directory for CUDA headers.
# => CUDA_TARGET_LINK		: CUDA RT library.
# => CUDA_CUT_INCLUDE		: include directory for CUDA SDK headers (cutil.h).
# => CUDA_CUT_TARGET_LINK	: SDK libraries.
IF(ENABLE_FEATURE_CUDA)
    FIND_PACKAGE(CUDA REQUIRED)
ENDIF()

##########################################################################
# Find "Boost"
# => Boost_INCLUDE_DIR	: include directories
# => Boost_LIBRARIES	: libraries
# => Boost_LIBRARY_DIRS	: path to libraries
SET(Boost_FIND_QUIETLY FALSE)
IF(WIN32)
    SET(Boost_USE_STATIC_LIBS TRUE)
ELSE()
    SET(Boost_USE_STATIC_LIBS FALSE)
ENDIF()

IF(NOT Boost_USE_STATIC_LIBS)
    ADD_DEFINITIONS(-DBOOST_ALL_DYN_LINK)
ENDIF()

IF(Boost_USE_STATIC_LIBS)
    FIND_PACKAGE(Boost REQUIRED thread date_time program_options unit_test_framework filesystem regex system serialization)
ELSE()
    FIND_PACKAGE(Boost REQUIRED thread date_time program_options prg_exec_monitor unit_test_framework filesystem regex system serialization)
ENDIF()


##########################################################################
# Find "Log4cxx" => "Apache C++ Logging Library"
# => LOG4CXX_INCLUDE_DIR	: include directories
# => LOG4CXX_LIBRARIES		: libraries
SET(LOG4CXX_FIND_QUIETLY FALSE)
FIND_PACKAGE(LOG4CXX REQUIRED)

##########################################################################
# Find "TBB" => "Intel Threading Building Blocks"
# TBB_INCLUDE_DIRS, where to find task_scheduler_init.h, etc.
# TBB_LIBRARIES, the libraries to link against to use TBB.
#IF(WIN32)
#	IF(CMAKE_SIZEOF_VOID_P EQUAL 8)
#        SET(TBB_ARCHITECTURE "intel64")
#	ELSE(CMAKE_SIZEOF_VOID_P EQUAL 8)
#        SET(TBB_ARCHITECTURE "ia32")
#	ENDIF(CMAKE_SIZEOF_VOID_P EQUAL 8)
#	IF(TBB_VERSION STREQUAL "tbb30")
##        SET(TBB_INSTALL_DIR ${CMAKE_SOURCE_DIR}/dep/windows/tbb/tbb30_20100406oss/)
#        SET(TBB_INSTALL_DIR ${CMAKE_SOURCE_DIR}/dep/windows/tbb/tbb30_20101215oss/)
#    ELSE()
#        SET(TBB_INSTALL_DIR ${CMAKE_SOURCE_DIR}/dep/windows/tbb/tbb22_004oss/)
#    ENDIF()
#ELSE()
#	IF(CMAKE_SIZEOF_VOID_P EQUAL 8)
#    message( STATUS " intel64" )
#		SET(TBB_ARCHITECTURE "intel64")
#		SET(TBB_COMPILER "cc4.1.0_libc2.4_kernel2.6.16.21")
#		IF(TBB_VERSION STREQUAL "tbb30")
##			SET(TBB_INSTALL_DIR ${CMAKE_SOURCE_DIR}/dep/linux/tbb/tbb30_20100406oss/)
#            SET(TBB_INSTALL_DIR ${CMAKE_SOURCE_DIR}/dep/linux/tbb/tbb30_20101215oss/)
#		ELSE()
#			SET(TBB_INSTALL_DIR ${CMAKE_SOURCE_DIR}/dep/linux/tbb/tbb22_004oss/)
#		ENDIF()
#    ELSE()
#        message( STATUS " ia32 " )
#    		SET(TBB_ARCHITECTURE "ia32")
#		SET(TBB_INSTALL_DIR /opt/intel/tbb/ )
#	ENDIF()
#ENDIF(WIN32)
#FIND_PACKAGE(TBB REQUIRED)
IF(ENABLE_FEATURE_TBB)
    FIND_PACKAGE(SystemTBB REQUIRED)
ENDIF()
#SET(TBB_LIBRARIES tbb tbbmalloc)
#SET(TBB_FOUND 1)

##########################################################################
# Find "AMQ" => "ActiveMQ-CPP"
# => AMQ_INCLUDES		: ActiveMQ-CPP include directory
# => AMQ_LIBS			: ActiveMQ-CPP libraries
#FIND_PACKAGE(AMQ)

##########################################################################
# Find "EV" => "LibEv"
# => EV_INCLUDE_DIR		: LibEv include directory
# => EV_LIBRARIES		: LibEv libraries
FIND_PACKAGE(EV)

##########################################################################
# Find "RDMA" => "rdmacm & ibverbs"
# => RDMA_INCLUDE_DIRS	: RDMA include directory
# => RDMA_LIBRARIES		: RDMA libraries
IF(ENABLE_FEATURE_RDMA)
    #FIND_PACKAGE(RDMA REQUIRED)
    FIND_PACKAGE(RDMA )
ENDIF()

##########################################################################
# Find "TICPP" => "TinyXML++"
# => TICPP_INCLUDE_DIRS	: TICPP include directory
# => TICPP_LIBRARIES	: TICPP libraries
IF(ENABLE_FEATURE_TICPP)
    FIND_PACKAGE(TICPP)
ENDIF()

##########################################################################
# Find "Thrust" => http://code.google.com/p/thrust/
# => THRUST_INCLUDE_DIRS	: THRUST include directory
IF(ENABLE_FEATURE_CUDA)
    FIND_PACKAGE(Thrust REQUIRED)
ENDIF()

##########################################################################
# Find "OptiX" => NVIDIA OptiX RayTracing Library
# => OPTIX_INCLUDE_DIR : OptiX include directory
# => OPTIX_LIBRARIES   : OptiX libraries
IF(ENABLE_FEATURE_CUDA)
    FIND_PACKAGE(OptiX)
ENDIF()

##########################################################################
# Find "COROSYNC" => "OpenAIS Corosync Engine"
# => COROSYNC_INCLUDE_DIRS	: COROSYNC include directory
# => COROSYNC_LIBRARIES	: COROSYNC libraries
IF(ENABLE_FEATURE_COROSYNC)
    FIND_PACKAGE(Corosync REQUIRED)
ENDIF()


##########################################################################
# Find "RabbitMQ" => "Messaging passing system"
IF(ENABLE_FEATURE_RABBITMQ)
#    FIND_PACKAGE(Rabbit REQUIRED)
ENDIF()

##########################################################################
# Find "JustThread" => C++0x threading library
# => JUSTTHREAD_INCLUDE_DIR	: Just Thread include directory
# => JUSTTHREAD_LIBRARIES_DYNAMIC	: Just Thread libraries (dynamic version)
# => JUSTTHREAD_LIBRARIES_STATIC    : Just Thread libraries (static version
IF(ENABLE_FEATURE_JUSTTHREAD)
    FIND_PACKAGE(JustThread REQUIRED)
ENDIF()

##########################################################################
# Find "Openssl" => The Open Source toolkit for SSL/TLS
# => OPENSSL_FOUND : system has the OpenSSL library
# => OPENSSL_INCLUDE_DIR : the OpenSSL include directory
# => OPENSSL_LIBRARIES : The libraries needed to use OpenSSL
FIND_PACKAGE(OpenSSL)
IF( OPENSSL_FOUND )
	message( "-- Found OpenSSL" )
ENDIF()

##########################################################################
# Find "PythonLibs"
FIND_PACKAGE(PythonLibs)
IF( PYTHONLIBS_FOUND )
    message( "-- Found PythonLibs" )
ENDIF()

##########################################################################
# Find "ZLIB"
FIND_PACKAGE(ZLIB)
IF( ZLIB_FOUND )
    message( "-- Found Zlib Version (${ZLIB_VERSION_STRING})" )
ENDIF()

##########################################################################
# Add build-enable preprocessors to global compilation definition
IF(APRCORE_FOUND)
	ADD_DEFINITIONS(-DBUILD_WITH_APRCORE)
ENDIF(APRCORE_FOUND)

IF(APRUTIL_FOUND)
	ADD_DEFINITIONS(-DBUILD_WITH_APRUTIL)
ENDIF(APRUTIL_FOUND)

IF(MONGO_FOUND)
	ADD_DEFINITIONS(-DBUILD_WITH_MONGO)
ENDIF(MONGO_FOUND)

IF(THRIFT_FOUND)
	ADD_DEFINITIONS(-DBUILD_WITH_THRIFT)
ENDIF(THRIFT_FOUND)

IF(CASSANDRA_FOUND)
	ADD_DEFINITIONS(-DBUILD_WITH_CASSANDRA)
ENDIF(CASSANDRA_FOUND)

IF(ANN_FOUND)
    ADD_DEFINITIONS(-DBUILD_WITH_ANN)
ENDIF(ANN_FOUND)

IF(GRAPHVIZ_FOUND)
    ADD_DEFINITIONS(-DBUILD_WITH_GRAPHVIZ)
ENDIF(GRAPHVIZ_FOUND)

IF(BISON_FOUND)
    ADD_DEFINITIONS(-DBUILD_WITH_BISON)
ENDIF(BISON_FOUND)

IF(FLEX_FOUND)
    ADD_DEFINITIONS(-DBUILD_WITH_FLEX)
ENDIF(FLEX_FOUND)

IF(TINYXML_FOUND)
    ADD_DEFINITIONS(-DBUILD_WITH_TINYXML)
ENDIF(TINYXML_FOUND)

IF(CUDA_FOUND)
	ADD_DEFINITIONS(-DBUILD_WITH_CUDA)
ENDIF(CUDA_FOUND)

IF(Boost_FOUND)
	ADD_DEFINITIONS(-DBUILD_WITH_BOOST)
ENDIF(Boost_FOUND)

IF(LOG4CXX_FOUND)
	ADD_DEFINITIONS(-DBUILD_WITH_LOG4CXX)
ENDIF(LOG4CXX_FOUND)

IF(TBB_FOUND)
	ADD_DEFINITIONS(-DBUILD_WITH_TBB)
ENDIF(TBB_FOUND)

IF(EV_FOUND)
	ADD_DEFINITIONS(-DBUILD_WITH_EV)
ENDIF(EV_FOUND)

IF(RDMA_FOUND)
	ADD_DEFINITIONS(-DBUILD_WITH_RDMA)
ENDIF(RDMA_FOUND)

IF(TICPP_FOUND)
	ADD_DEFINITIONS(-DBUILD_WITH_TICPP)
ENDIF(TICPP_FOUND)

IF(CUDPP_FOUND)
	ADD_DEFINITIONS(-DBUILD_WITH_CUDPP)
ENDIF(CUDPP_FOUND)

IF(THRUST_FOUND)
	ADD_DEFINITIONS(-DBUILD_WITH_THRUST)
ENDIF(THRUST_FOUND)

IF(COROSYNC_FOUND)
	ADD_DEFINITIONS(-DBUILD_WITH_COROSYNC)
ENDIF(COROSYNC_FOUND)

IF(RABBITMQ_FOUND)
	ADD_DEFINITIONS(-DBUILD_WITH_RABBITMQ)
ENDIF(RABBITMQ_FOUND)

IF(JUSTTHREAD_FOUND)
	ADD_DEFINITIONS(-DBUILD_WITH_JUSTTHREAD)
ENDIF(JUSTTHREAD_FOUND)

IF(PYTHONLIBS_FOUND)
    ADD_DEFINITIONS(-DBUILD_WITH_PYTHONLIBS)
ENDIF(PYTHONLIBS_FOUND)

##########################################################################
# Add all header paths to default search
SET(ZILLIANS_INCLUDE_DIRS "")

IF(APRCORE_FOUND)
	LIST(APPEND ZILLIANS_INCLUDE_DIRS ${APRCORE_INCLUDE_DIR})
ENDIF(APRCORE_FOUND)

IF(APRUTIL_FOUND)
	LIST(APPEND ZILLIANS_INCLUDE_DIRS ${APRUTIL_INCLUDE_DIR})
ENDIF(APRUTIL_FOUND)

IF(MONGO_FOUND)
	LIST(APPEND ZILLIANS_INCLUDE_DIRS ${MONGO_INCLUDE_DIR})
ENDIF(MONGO_FOUND)

IF(THRIFT_FOUND)
    LIST(APPEND ZILLIANS_INCLUDE_DIRS ${THRIFT_INCLUDE_DIR})
ENDIF(THRIFT_FOUND)

IF(CASSANDRA_FOUND)
	LIST(APPEND ZILLIANS_INCLUDE_DIRS ${CASSANDRA_INCLUDE_DIR})
ENDIF(CASSANDRA_FOUND)

IF(ANN_FOUND)
    LIST(APPEND ZILLIANS_INCLUDE_DIRS ${ANN_INCLUDE_DIR})
ENDIF(ANN_FOUND)

IF(GRAPHVIZ_FOUND)
    LIST(APPEND ZILLIANS_INCLUDE_DIRS ${GRAPHVIZ_INCLUDE_DIR})
ENDIF(GRAPHVIZ_FOUND)

IF(BISON_FOUND)
    LIST(APPEND ZILLIANS_INCLUDE_DIRS ${BISON_INCLUDE_DIR})
ENDIF(BISON_FOUND)

IF(FLEX_FOUND)
    LIST(APPEND ZILLIANS_INCLUDE_DIRS ${FLEX_INCLUDE_DIR})
ENDIF(FLEX_FOUND)

IF(TINYXML_FOUND)
    LIST(APPEND ZILLIANS_INCLUDE_DIRS ${TINYXML_INCLUDE_DIR})
ENDIF(TINYXML_FOUND)

IF(CUDA_FOUND)
	LIST(APPEND ZILLIANS_INCLUDE_DIRS ${CUDA_INCLUDE_DIRS} ${CUDA_CUT_INCLUDE_DIR})
	MESSAGE(STATUS "CUDA version: ${CUDA_VERSION}")
	IF(CUDA_VERSION VERSION_GREATER "3.1")
	    MESSAGE(STATUS "CUDA enable 64bit cuda device pointer")
	    ADD_DEFINITIONS(-DENABLE_CUDA_POINTER_64BIT)
	ENDIF()
ENDIF(CUDA_FOUND)

IF(Boost_FOUND)
	LIST(APPEND ZILLIANS_INCLUDE_DIRS ${Boost_INCLUDE_DIRS})
ENDIF(Boost_FOUND)

IF(LOG4CXX_FOUND)
	LIST(APPEND ZILLIANS_INCLUDE_DIRS ${LOG4CXX_INCLUDE_DIR})
ENDIF(LOG4CXX_FOUND)

IF(TBB_FOUND)
	LIST(APPEND ZILLIANS_INCLUDE_DIRS ${TBB_INCLUDE_DIRS})
ENDIF(TBB_FOUND)

IF(EV_FOUND)
	LIST(APPEND ZILLIANS_INCLUDE_DIRS ${EV_INCLUDE_DIR})
ENDIF(EV_FOUND)

IF(RDMA_FOUND)
	LIST(APPEND ZILLIANS_INCLUDE_DIRS ${RDMA_INCLUDE_DIRS})
ENDIF(RDMA_FOUND)

IF(TICPP_FOUND)
	LIST(APPEND ZILLIANS_INCLUDE_DIRS ${TICPP_INCLUDE_DIR})
ENDIF(TICPP_FOUND)

IF(CUDPP_FOUND)
	LIST(APPEND ZILLIANS_INCLUDE_DIRS ${CUDPP_INCLUDE_DIR})
ENDIF(CUDPP_FOUND)

IF(THRUST_FOUND)
	LIST(APPEND ZILLIANS_INCLUDE_DIRS ${THRUST_INCLUDE_DIR})
ENDIF(THRUST_FOUND)

IF(COROSYNC_FOUND)
	LIST(APPEND ZILLIANS_INCLUDE_DIRS ${COROSYNC_INCLUDE_DIR})
ENDIF(COROSYNC_FOUND)

IF(JUSTTHREAD_FOUND)
	LIST(APPEND ZILLIANS_INCLUDE_DIRS ${JUSTTHREAD_INCLUDE_DIR})
ENDIF(JUSTTHREAD_FOUND)

IF(PYTHONLIBS_FOUND)
    LIST(APPEND ZILLIANS_INCLUDE_DIRS ${PYTHON_INCLUDE_DIRS})
ENDIF(PYTHONLIBS_FOUND)

IF(ZLIB_FOUND)
    LIST(APPEND ZILLIANS_INCLUDE_DIRS ${ZLIB_INCLUDE_DIRS})
ENDIF(ZLIB_FOUND)

INCLUDE_DIRECTORIES(
		${ZILLIANS_INCLUDE_DIRS}
		)

IF(ENABLE_FEATURE_CUDA)
    CUDA_INCLUDE_DIRECTORIES(
    		${ZILLIANS_INCLUDE_DIRS}
    		)
ENDIF()

##########################################################################
# Add all library paths to default link
SET(ZILLIANS_LINK_DIRS "")

IF(Boost_FOUND)
	LIST(APPEND ZILLIANS_LINK_DIRS ${Boost_LIBRARY_DIRS})
ENDIF(Boost_FOUND)

IF(TBB_FOUND)
	LIST(APPEND ZILLIANS_LINK_DIRS ${TBB_LIBRARY_DIRS})
ENDIF(TBB_FOUND)

LINK_DIRECTORIES(
		${ZILLIANS_LINK_DIRS}
		)

##########################################################################
# Add all dependencies to ZILLIANS_DEP_LIBS variable
SET(ZILLIANS_DEP_LIBS "")

IF(APRCORE_FOUND)
	LIST(APPEND ZILLIANS_DEP_LIBS ${APRCORE_LIBRARIES})
ENDIF(APRCORE_FOUND)

IF(APRUTIL_FOUND)
	LIST(APPEND ZILLIANS_DEP_LIBS ${APRUTIL_LIBRARIES})
ENDIF(APRUTIL_FOUND)

#IF(MONGO_FOUND)
#	LIST(APPEND ZILLIANS_DEP_LIBS ${MONGO_LIBRARIES})
#ENDIF(MONGO_FOUND)

#IF(THRIFT_FOUND)
#	LIST(APPEND ZILLIANS_DEP_LIBS ${THRIFT_LIBRARIES})
#ENDIF(THRIFT_FOUND)

#IF(CASSANDRA_FOUND)
#   LIST(APPEND ZILLIANS_DEP_LIBS ${CASSANDRA_LIBRARIES})
#ENDIF(CASSANDRA_FOUND)

IF(Boost_FOUND)
	LIST(APPEND ZILLIANS_DEP_LIBS ${Boost_LIBRARIES})
ENDIF(Boost_FOUND)

IF(LOG4CXX_FOUND)
	LIST(APPEND ZILLIANS_DEP_LIBS ${LOG4CXX_LIBRARIES})
ENDIF(LOG4CXX_FOUND)

IF(TBB_FOUND)
	LIST(APPEND ZILLIANS_DEP_LIBS ${TBB_LIBRARIES})
ENDIF(TBB_FOUND)

IF(ZLIB_FOUND)
	LIST(APPEND ZILLIANS_DEP_LIBS ${ZLIB_LIBRARIES})
ENDIF(ZLIB_FOUND)

#IF(RDMA_FOUND)
    #LIST(APPEND ZILLIANS_DEP_LIBS "/usr/lib/librdmacm.a;/usr/lib/libibverbs.a")
	#LIST(APPEND ZILLIANS_DEP_LIBS ${RDMA_LIBRARIES})
#ENDIF(RDMA_FOUND)

#IF(ENABLE_FEATURE_RDMA)
#    SET(RDMA_FOUND TRUE)
#        ADD_DEFINITIONS(-DBUILD_WITH_RDMA)
#ENDIF()

IF(PYTHONLIBS_FOUND)
    LIST(APPEND ZILLIANS_DEP_LIBS ${PYTHON_LIBRARIES})
ENDIF(PYTHONLIBS_FOUND)

SET(ZILLIANS_DEP_LIBS ${ZILLIANS_DEP_LIBS} CACHE STRING "Gloabl depencent libraries" FORCE)
MESSAGE(STATUS "The global dependecies: ${ZILLIANS_DEP_LIBS}")

MARK_AS_ADVANCED(ZILLIANS_DEP_LIBS)

