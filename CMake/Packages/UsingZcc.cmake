
# ZSCRIPT_TO_BC
#
# OPTIONS
#    ZS_SRC_FILES        zscript files
#    ZS_API_FILES        zscript api files
#    ZCC_OPTIONS          -d -b -a game_id
#
MACRO( ZSCRIPT_TO_BC BC_PATH )
    # parse the argument options
    SET(__option_catalogries "ZS_SRC_FILES;ZS_API_FILES;ZCC_OPTIONS;ZCC_ARCH")
    SET(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set) 
    
    # check if the number of targets specified is wrong
    hashmap(GET __options_set "ZS_SRC_FILES"  __zs_src_files)
    hashmap(GET __options_set "ZS_API_FILES"  __zs_api_files)
    hashmap(GET __options_set "ZCC_OPTIONS"    __zs_options)
    hashmap(GET __options_set "ZCC_ARCH"    __zcc_arch)

    IF(NOT DEFINED __zcc_arch )
        SET( __zcc_arch "cpu" )
    ENDIF()

    SET( __zs_src_abs_files )
	FOREACH( arg ${__zs_src_files} )
        if(IS_ABSOLUTE "${arg}")
            LIST( APPEND __zs_src_abs_files "${arg}")
        else()
            LIST( APPEND __zs_src_abs_files "${CMAKE_CURRENT_SOURCE_DIR}/${arg}")
        endif()
	ENDFOREACH( arg )
        
    STRING(TOLOWER ${__zcc_arch} __zcc_arch_tolower)
    IF(${__zcc_arch_tolower} STREQUAL "gpu")
        SET(ZCC_ARCH_GPU 1)
        LIST(APPEND __zcc_options "--arch" "gpu")
    ELSEIF(${__zcc_arch_tolower} STREQUAL "cpu")
        SET(ZCC_ARCH_CPU 1)
        LIST(APPEND __zcc_options "--arch" "cpu")
    ELSE()
        MESSAGE(FATAL_ERROR "MACRO: ZSCRIPT_TO_BC. Unkown zcc arch. Please check it.")
    ENDIF()

	add_custom_command(
		OUTPUT ${BC_PATH}
		DEPENDS ${__zs_src_files} ${__zs_api_files}
		DEPENDS ${ZCC_BC}
		COMMAND ${ZCC_BC} ${__zs_options} ${__zs_src_abs_files} ${__zs_api_files} -o ${BC_PATH}
        )
ENDMACRO()

MACRO( LLVMBC_TO_C BC_PATH C_PATH )
	add_custom_target(
        just_a_test
		OUTPUT ${C_PATH}
        DEPENDS ${BC_PATH} ${ZILLIANS_LLC} 
		COMMAND ${ZILLIANS_LLC} -o ${C_PATH} ${BC_PATH} -march="c"
        ) 
ENDMACRO( LLVMBC_TO_C C_PATH )

# input: TGT_NAME
# input: BC_PATH
# output: OUTPUT_LIB
MACRO( LLVMBC_TO_X86 TGT_NAME BC_PATH OUTPUT_LIB )
    set( ${OUTPUT_LIB} ${CMAKE_CURRENT_BINARY_DIR}/${TGT_NAME}.a )
    IF( ZILLIANS_WS_DEBUG )
	add_custom_target(
        ${TGT_NAME}
        DEPENDS ${BC_PATH} ${ZILLIANS_LLC}
		#COMMAND ${ZILLIANS_LLC}  -relocation-model=pic -o ${BC_PATH}.o ${BC_PATH}  -march=x86-64 -filetype=obj
		COMMAND ${ZILLIANS_LLC}  -relocation-model=pic -o ${BC_PATH}.c ${BC_PATH}  -march="c"
        COMMAND gcc -g ${BC_PATH}.c -o ${BC_PATH}.o -c -fPIC
        COMMAND ar cq ${TGT_NAME}.a ${BC_PATH}.o
        )

    ELSE()
	add_custom_target(
        ${TGT_NAME}
        DEPENDS ${BC_PATH} ${ZILLIANS_LLC}
		#COMMAND ${ZILLIANS_LLC}  -relocation-model=pic -o ${BC_PATH}.o ${BC_PATH}  -march=x86-64 -filetype=obj
		COMMAND ${ZILLIANS_LLC}  -relocation-model=pic -o ${BC_PATH}.s ${BC_PATH}  -march=x86-64 -filetype=asm
        COMMAND g++ ${BC_PATH}.s -o ${BC_PATH}.o -c -fPIC
        COMMAND ar cq ${TGT_NAME}.a ${BC_PATH}.o
        )
    ENDIF()
    
#	add_custom_target(
#        ${TGT_NAME}
#        DEPENDS ${BC_PATH}
#        COMMAND ${LLVM_LD} --native -r  -relocation-model=dynamic-no-pic  ${BC_PATH} -o ${CMAKE_CURRENT_BINARY_DIR}/${TGT_NAME}.a
#        ) 
   set_source_files_properties( ${CMAKE_CURRENT_BINARY_DIR}/${TGT_NAME}.a PROPERTIES GENERATED 1)
ENDMACRO( LLVMBC_TO_X86 C_PATH )

MACRO( TARGET_ADD_LLVMBC TGT BCPATH )
    LLVMBC_TO_X86(
        ${TGT}-bc-static
        ${BCPATH}
        output_static_library
    )
    ADD_DEPENDENCIES( ${TGT} ${TGT}-bc-static )
    TARGET_LINK_LIBRARIES(
        ${TGT}
        ${output_static_library}
     )
ENDMACRO( TARGET_ADD_LLVMBC )

# TARGET_ADD_ZSCRIPT
#
# OPTIONS
#    ZS_SRC_FILES        zscript files
#    ZS_API_FILES        zscript api files
#    ZCC_OPTIONS          -d -b -a game_id
#
MACRO( TARGET_ADD_ZSCRIPT TGT )
    # parse the argument options
    SET(__option_catalogries "ZS_API_FILES;ZCC_OPTIONS;ZS_SRC_FILES;ZCC_ARCH")
    SET(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set) 
    
    # check if the number of targets specified is wrong
    hashmap(GET __options_set "ZS_SRC_FILES"  __zs_src_files)
    hashmap(GET __options_set "ZS_API_FILES"  __zs_api_files)
    hashmap(GET __options_set "ZCC_ARCH"      __zcc_arch)
    hashmap(GET __options_set "ZCC_OPTIONS"    __zs_options)

    IF(NOT DEFINED __zcc_arch )
        SET( __zcc_arch "cpu" )
    ENDIF()
        
    ZSCRIPT_TO_BC(
            ${CMAKE_CURRENT_BINARY_DIR}/${TGT}.tmp.bc
            ZS_SRC_FILES    ${__zs_src_files}
            ZS_API_FILES    ${__zs_api_files}
            ZCC_OPTIONS      ${__zs_options}
            ZCC_ARCH        ${__zcc_arch}
    )
    TARGET_ADD_LLVMBC(
        ${TGT}
        ${CMAKE_CURRENT_BINARY_DIR}/${TGT}.tmp.bc
    )

ENDMACRO( TARGET_ADD_ZSCRIPT )



# BUILD_GW
#     build world gateway game module
#
# OPTIONS
#    ZS_SRC_FILES        zscript files
#    ZS_API_FILES        zscript api files
#    ZS_GAME_ID          unique game id
#
MACRO(BUILD_GW)
    INCLUDE_DIRECTORIES(
    	${PROJECT_NODE_SOURCE_DIR}/include/
    	${PROJECT_COMMON_SOURCE_DIR}/include/
    	${PROJECT_FRAMEWORK_SOURCE_DIR}/include/
    	${PROJECT_PROTOCOL_SOURCE_DIR}/include/
    	${CMAKE_CURRENT_BINARY_DIR}/gwStub/
    	)

    # parse the argument options
    SET(__option_catalogries "ZS_SRC_FILES;ZS_API_FILES;ZS_GAME_ID")
    SET(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set) 
    
    # check if the number of targets specified is wrong
    hashmap(GET __options_set "ZS_SRC_FILES"  __zs_src_files)
    hashmap(GET __options_set "ZS_API_FILES"  __zs_api_files)
    hashmap(GET __options_set "ZS_GAME_ID"    __zs_game_id)
    LIST(LENGTH __zs_game_id __number_of_game_id)
#    IF(NOT __number_of_game_name EQUAL 1)
#        MESSAGE(FATAL_ERROR "can't register more than one game name!")
#    ENDIF()
    IF(NOT __number_of_game_id EQUAL 1)
        MESSAGE(FATAL_ERROR "can't register more than one game id!")
    ENDIF()

    SET(gw_stub_files "")
    ZS2GW(gw_stub_files gwStub ${__zs_game_id} ${__zs_src_files} ${__zs_api_files})

    ADD_LIBRARY(GWGameModule-${PROJECT_NAME} SHARED
        ${gw_stub_files}
        )

    INCLUDE_DIRECTORIES(
        ${EXECUTABLE_OUTPUT_PATH}
        )
    
    TARGET_LINK_LIBRARIES(GWGameModule-${PROJECT_NAME}
	    zillians-plugin
        )

    ADD_CUSTOM_COMMAND(TARGET GWGameModule-${PROJECT_NAME}
        POST_BUILD COMMAND cmake -E make_directory ${LIBRARY_OUTPUT_PATH}/node/world-gw/
        POST_BUILD COMMAND cmake -E copy ${LIBRARY_OUTPUT_PATH}/libGWGameModule-${PROJECT_NAME}.so ${LIBRARY_OUTPUT_PATH}/node/world-gw/libGameModule.so
        POST_BUILD COMMAND cmake -E remove -f  ${LIBRARY_OUTPUT_PATH}/libGWGameModule-${PROJECT_NAME}.so
        POST_BUILD COMMAND cmake -E copy ${CMAKE_CURRENT_BINARY_DIR}/gwStub/G_${__zs_game_id}GameModule.module ${LIBRARY_OUTPUT_PATH}/node/world-gw/GameModule.module
       	)

    ADD_DEPENDENCIES(${PROJECT_NAME}
        GWGameModule-${PROJECT_NAME}
        )
ENDMACRO()

# BUILD_WS_MT
#     build world server game module
#
# OPTIONS
#    ZS_SRC_FILES        zscript files
#    ZS_API_FILES        zscript api files
#    ZS_GAME_ID          unique game id
#
MACRO(BUILD_WS_MT)

    INCLUDE_DIRECTORIES(
    	${PROJECT_NODE_SOURCE_DIR}/include/
    	${PROJECT_COMMON_SOURCE_DIR}/include/
    	${PROJECT_FRAMEWORK_SOURCE_DIR}/include/
    	${PROJECT_PROTOCOL_SOURCE_DIR}/include/
    	${CMAKE_CURRENT_BINARY_DIR}/wsStub/
    	)

    # parse the argument options
    SET(__option_catalogries "ZS_SRC_FILES;ZS_API_FILES;ZS_GAME_ID")
    SET(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set) 
    
    # check if the number of targets specified is wrong
    hashmap(GET __options_set "ZS_SRC_FILES"  __zs_src_files)
    hashmap(GET __options_set "ZS_API_FILES"  __zs_api_files)
    hashmap(GET __options_set "ZS_GAME_ID"    __zs_game_id)
    LIST(LENGTH __zs_game_id __number_of_game_id)
#    IF(NOT __number_of_game_name EQUAL 1)
#        MESSAGE(FATAL_ERROR "can't register more than one game name!")
#    ENDIF()
    IF(NOT __number_of_game_id EQUAL 1)
        MESSAGE(FATAL_ERROR "can't register more than one game id!")
    ENDIF()

    SET(ws_stub_files "")
    SET(ws_stub_dispatch "")
    ZS2WS(ws_stub_files ${PROJECT_NAME} ${__zs_game_id} ${__zs_src_files} ${__zs_api_files})
    ZS2WS_STUB_DISPATCH(ws_stub_dispatch ${PROJECT_NAME} ZS_GAME_IDS ${__zs_game_id})

    add_library( WSGameModuleMT-${PROJECT_NAME} SHARED
        ${PROJECT_NODE_SOURCE_DIR}/src/modzillians-world-server-kernel-mt/WorldServerKernelMultiThreadComponentImpl.cpp
        ${ws_stub_files}
        ${ws_stub_dispatch}
    )

    TARGET_ADD_ZSCRIPT(
        WSGameModuleMT-${PROJECT_NAME}
        ZS_SRC_FILES  ${__zs_src_files}
        ZS_API_FILES  ${__zs_api_files}
        ZCC_ARCH "cpu"
        ZCC_OPTIONS "-b" "-d" "-a" ${__zs_game_id}
        )

    TARGET_LINK_LIBRARIES(WSGameModuleMT-${PROJECT_NAME}
        zillians-framework-vw-processors-mt
        zillians-framework-vw-processors-database-mt
        zillians-framework-vw-services-mt
        zillians-framework-vw-api-mt
        zillians-framework-vw-api-internal-mt
        zillians-framework-vw-mt
        zillians-common-core
        zillians-plugin
        zillians-database
        )
   
    ADD_CUSTOM_COMMAND(
        TARGET WSGameModuleMT-${PROJECT_NAME}
    	POST_BUILD COMMAND cmake -E make_directory ${LIBRARY_OUTPUT_PATH}/node/world-server/mt
    	POST_BUILD COMMAND cmake -E copy ${LIBRARY_OUTPUT_PATH}/libWSGameModuleMT-${PROJECT_NAME}.so ${LIBRARY_OUTPUT_PATH}/node/world-server/mt/libWorldServerKernelMultiThreadModule.so
    	POST_BUILD COMMAND cmake -E remove -f ${LIBRARY_OUTPUT_PATH}/libWSGameModuleMT-${PROJECT_NAME}.so
    	POST_BUILD COMMAND cmake -E copy ${PROJECT_NODE_SOURCE_DIR}/src/modzillians-world-server-kernel-mt/WorldServerKernelMultiThreadModule.module ${LIBRARY_OUTPUT_PATH}/node/world-server/mt/WorldServerKernelMultiThreadModule.module
    	)

    ADD_DEPENDENCIES(${PROJECT_NAME}
        WSGameModuleMT-${PROJECT_NAME}
        )
ENDMACRO()

# BUILD_WS_FERMI
#     build world server for fermi game module
#
# OPTIONS
#    ZS_SRC_FILES        zscript files
#    ZS_API_FILES        zscript api files
#    ZS_GAME_ID          unique game id
#
MACRO(BUILD_WS_FERMI)

    ADD_DEFINITIONS(-DENABLE_FEATURE_FERMI)
    
    INCLUDE_DIRECTORIES(
    	${PROJECT_NODE_SOURCE_DIR}/include/
    	${PROJECT_COMMON_SOURCE_DIR}/include/
    	${PROJECT_FRAMEWORK_SOURCE_DIR}/include/
    	${PROJECT_PROTOCOL_SOURCE_DIR}/include/
    	${CMAKE_CURRENT_BINARY_DIR}/wsStub/
    	)
    IF( ENABLE_FEATURE_CUDA )
    # parse the argument options
    SET(__option_catalogries "ZS_SRC_FILES;ZS_API_FILES;ZS_GAME_ID")
    SET(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set) 
    
    # check if the number of targets specified is wrong
    hashmap(GET __options_set "ZS_SRC_FILES"  __zs_src_files)
    hashmap(GET __options_set "ZS_API_FILES"  __zs_api_files)
    hashmap(GET __options_set "ZS_GAME_ID"    __zs_game_id)
    LIST(LENGTH __zs_game_id __number_of_game_id)
    
    IF(NOT __number_of_game_id EQUAL 1)
        MESSAGE(FATAL_ERROR "can't register more than one game id!")
    ENDIF()

    SET(ws_stub_files "")
    SET(ws_stub_dispatch "")
    ZS2WS(ws_stub_files wsStub ${__zs_game_id} ${__zs_src_files} ${__zs_api_files})
    ZS2WS_STUB_DISPATCH(ws_stub_dispatch ${PROJECT_NAME} ZS_GAME_IDS ${__zs_game_id})

    ZS_2_NATIVE_CODE(
        TARGET_NAME WSGameModuleFermi-${PROJECT_NAME}
        CPP_SRC_FILES ${PROJECT_NODE_SOURCE_DIR}/src/modzillians-world-server-kernel-fermi/WorldServerKernelFermiComponentImpl.cpp
                      ${ws_stub_files}
                      ${ws_stub_dispatch}
        ZS_SRC_FILES  ${__zs_src_files}
        ZS_API_FILES  ${__zs_api_files}
        ZCC_ARCH "gpu"
        ZCC_OPTIONS "-b" "-d" "-a" ${__zs_game_id}
        )

    TARGET_LINK_LIBRARIES(WSGameModuleFermi-${PROJECT_NAME}
        zillians-framework-vw-processors-fermi
        zillians-framework-vw-processors-database-fermi
        zillians-framework-vw-services-fermi
        zillians-framework-vw-api-mt
        zillians-framework-vw-api-fermi
        zillians-framework-vw-api-internal-mt
        zillians-framework-vw-api-internal-fermi
        zillians-framework-vw-fermi
        zillians-common-core
        zillians-plugin
        zillians-database
        )
   
    ADD_CUSTOM_COMMAND(
        TARGET WSGameModuleFermi-${PROJECT_NAME}
    	POST_BUILD COMMAND cmake -E make_directory ${LIBRARY_OUTPUT_PATH}/node/world-server/fermi
    	POST_BUILD COMMAND cmake -E copy ${LIBRARY_OUTPUT_PATH}/libWSGameModuleFermi-${PROJECT_NAME}.so ${LIBRARY_OUTPUT_PATH}/node/world-server/fermi/libWorldServerKernelFermiModule.so
    	POST_BUILD COMMAND cmake -E remove -f ${LIBRARY_OUTPUT_PATH}/libWSGameModuleFermi-${PROJECT_NAME}.so
    	POST_BUILD COMMAND cmake -E copy ${PROJECT_NODE_SOURCE_DIR}/src/modzillians-world-server-kernel-fermi/WorldServerKernelFermiModule.module ${LIBRARY_OUTPUT_PATH}/node/world-server/fermi/WorldServerKernelFermiModule.module
    	)

    ADD_DEPENDENCIES(${PROJECT_NAME}
        WSGameModuleFermi-${PROJECT_NAME}
        )
    ELSE()
#        add_custom_target( WSGameModuleFermi-${PROJECT_NAME} ) 
    ENDIF()
ENDMACRO()
