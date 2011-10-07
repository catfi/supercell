
MACRO( ZS2OPT_C _target_NAME  _output_C )
	SET( ${_output_C} "${CMAKE_CURRENT_BINARY_DIR}/${_target_NAME}.zsall.c" )
	SET( _all_C "${CMAKE_CURRENT_BINARY_DIR}/${_target_NAME}.zsall.c" )
	SET( _output_OPT_BC "${CMAKE_CURRENT_BINARY_DIR}/${_target_NAME}.opt.bc" )
	SET( _output_ALL_BC "${CMAKE_CURRENT_BINARY_DIR}/${_target_NAME}.all.bc" )

######################Get File List and Option #############################
	SET( _found_options FALSE )
	SET( _options_  )
	SET( _FILE_NEED_TO_PARSE_ )
	FOREACH( arg ${ARGN} )
		if ( arg STREQUAL "ZCC_OPTIONS" )
			SET( _found_options TRUE )
		elseif ( _found_options )
			LIST(APPEND _options_ "${arg}")
		else ()
#			SET( _FILE_NEED_TO_PARSE_ ${_FILE_NEED_TO_PARSE_} ${CMAKE_CURRENT_SOURCE_DIR}/${arg} )
            LIST(APPEND _FILE_NEED_TO_PARSE_ "${arg}")
		endif()
	ENDFOREACH( arg )

#	message("2) options = ${_options_} ")
#	message("3) _FILE_NEED_TO_PARSE_ = ${_FILE_NEED_TO_PARSE_} ")
######################Get File List and Option (End)########################

	add_custom_command(
		OUTPUT ${_output_ALL_BC}
		DEPENDS ${_FILE_NEED_TO_PARSE_}
		DEPENDS ${ZCC_BC}
		COMMAND ${ZCC_BC} ${_options_} ${_FILE_NEED_TO_PARSE_} -o ${_output_ALL_BC}
        )
	add_custom_command(
		OUTPUT ${_output_OPT_BC}
		DEPENDS ${_output_ALL_BC}
		COMMAND ${LLVM_BINDIR}/opt -simplifycfg -instcombine -inline -globaldce -instcombine -simplifycfg -scalarrepl -mem2reg -verify -sccp -adce -licm -instcombine -dce -simplifycfg -deadargelim  -globaldce -deadtypeelim -ipconstprop -f ${_output_ALL_BC} -o ${_output_OPT_BC}
        )
	add_custom_command(
		OUTPUT ${_all_C}
		DEPENDS ${_output_OPT_BC}
		COMMAND ${LLVM_BINDIR}/llc ${_output_OPT_BC}  -o ${_all_C} -march=c
        )
ENDMACRO()

MACRO(ZS_GET_SOURCES_AND_OPTIONS _ZS_SRC_FILES _NORMAL_SRC_FILES _zcc_options)
	SET( ${_NORMAL_SRC_FILES} )
	SET( ${_ZS_SRC_FILES} )
	SET( _found_options FALSE )
	FOREACH(arg ${ARGN})
		GET_FILENAME_COMPONENT(ARG_FILE_EXT ${arg} EXT)
		if(ARG_FILE_EXT STREQUAL ".zs")
		    if(IS_ABSOLUTE "${arg}")
                LIST(APPEND ${_ZS_SRC_FILES} "${arg}")
            else()
                LIST(APPEND ${_ZS_SRC_FILES} "${CMAKE_CURRENT_SOURCE_DIR}/${arg}")
    		endif()
		elseif (arg STREQUAL "ZCC_OPTIONS")
			SET( _found_options TRUE )
		elseif (_found_options)
			LIST(APPEND ${_zcc_options} "${arg}")
		else()
			LIST(APPEND ${_NORMAL_SRC_FILES} "${arg}")
		endif()
	ENDFOREACH()
ENDMACRO()

MACRO( ZS_2_NATIVE_ADD _target_NAME _target_TYPE )
	SET( _zcc_options "-b" ) # default -b only
    ZS_GET_SOURCES_AND_OPTIONS(_ZS_SRC_FILES _NORMAL_SRC_FILES _zcc_options ${ARGN})
	ZS2OPT_C( ${_target_NAME} _output_C ${_ZS_SRC_FILES} "ZCC_OPTIONS" ${_zcc_options} )
	LIST(APPEND _NORMAL_SRC_FILES "${_output_C}")
	if( ${_target_TYPE} STREQUAL "EXE" )
		ADD_EXECUTABLE(${_target_NAME} ${_NORMAL_SRC_FILES})
	elseif( ${_target_TYPE} STREQUAL "SHARED" )
		ADD_LIBRARY(${_target_NAME} SHARED ${_NORMAL_SRC_FILES})
	endif()
ENDMACRO()

MACRO(ZS2CLI _output_files _target _game_id)
    SET(_zcc_options "")
    ZS_GET_SOURCES_AND_OPTIONS(_zs_files _normal_files _zcc_options ${ARGN})
    LIST(APPEND _zcc_options "-c" "${CMAKE_CURRENT_BINARY_DIR}/${_target}" "-a" "${_game_id}" )
    LIST(APPEND ${_output_files} "${CMAKE_CURRENT_BINARY_DIR}/${_target}/GameService.cpp")
    SET(__location_ZCC ${EXECUTABLE_OUTPUT_PATH}/zcc-client-old)
    FILE(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${_target} )
    ADD_CUSTOM_COMMAND(
		OUTPUT	${CMAKE_CURRENT_BINARY_DIR}/${_target}/GameService.cpp
		COMMAND ${__location_ZCC} ${_zcc_options} ${_zs_files}
		DEPENDS ${__location_ZCC} ${_zs_files}
		COMMENT "Generate client stub from " ${_zs_files}
        )
ENDMACRO()

MACRO(ZS2GW _output_files _target _game_id)
    SET(_zcc_gw_options "")
    ZS_GET_SOURCES_AND_OPTIONS(_zs_files _normal_files _zcc_gw_options ${ARGN})
    LIST(APPEND _zcc_gw_options "-g" "${CMAKE_CURRENT_BINARY_DIR}/${_target}" "-a" "${_game_id}" )
    LIST(APPEND ${_output_files} "${CMAKE_CURRENT_BINARY_DIR}/${_target}/G_${_game_id}_GameCommandTranslator.cpp")
	FILE(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${_target} )
	ADD_CUSTOM_COMMAND(
		OUTPUT	${CMAKE_CURRENT_BINARY_DIR}/${_target}/G_${_game_id}_GameCommandTranslator.cpp
		COMMAND ${ZCC_GW} ${_zcc_gw_options} ${_zs_files}
		DEPENDS ${ZCC_GW} ${_zs_files}
		COMMENT "Generate gateway stub from " ${_zs_files}
        )
ENDMACRO()

MACRO(ZS2WS _output_files _target _game_id)
    SET(_zcc_ws_options "")
    ZS_GET_SOURCES_AND_OPTIONS(_zs_files _normal_files _zcc_ws_options ${ARGN})
	LIST(APPEND _zcc_ws_options "-w" "${CMAKE_CURRENT_BINARY_DIR}/${_target}" "-a" "${_game_id}" )
    LIST(APPEND ${_output_files} "${CMAKE_CURRENT_BINARY_DIR}/${_target}/G_${_game_id}_CommonStub.cpp")
	LIST(APPEND ${_output_files} "${CMAKE_CURRENT_BINARY_DIR}/${_target}/G_${_game_id}_GameObjectDBRegistration.cpp")
    LIST(APPEND ${_output_files} "${CMAKE_CURRENT_BINARY_DIR}/${_target}/G_${_game_id}_StringLiteralFermiStub.cu")
    LIST(APPEND ${_output_files} "${CMAKE_CURRENT_BINARY_DIR}/${_target}/G_${_game_id}_StringLiteralStub.cpp")
	FILE(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${_target} )
	ADD_CUSTOM_COMMAND(
        OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/${_target}/G_${_game_id}_CommonStub.cpp
		OUTPUT	${CMAKE_CURRENT_BINARY_DIR}/${_target}/G_${_game_id}_GameObjectDBRegistration.cpp
        OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/${_target}/G_${_game_id}_StringLiteralFermiStub.cu
        OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/${_target}/G_${_game_id}_StringLiteralStub.cpp
		COMMAND ${ZCC_WS} ${_zcc_ws_options} ${_zs_files}
        COMMAND ${ZCC_STUB_DISPATCH} -g ${_game_id} -p "${CMAKE_CURRENT_BINARY_DIR}/${_target}"
        DEPENDS ${ZCC_WS} ${_zs_files}
		COMMENT "Generate world server stub from " ${_zs_files}
        )
ENDMACRO()

MACRO(ZS2WS_STUB_DISPATCH _output_files _target)
    # parse the argument options
    set(__option_catalogries "ZS_GAME_IDS")
    set(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set) 

    # check if the number of targets specified is wrong
    hashmap(GET __options_set "ZS_GAME_IDS" __game_id_list)

    LIST(APPEND ${_output_files} "${CMAKE_CURRENT_BINARY_DIR}/${_target}/CommonStubDispatch.cpp")
    LIST(APPEND ${_output_files} "${CMAKE_CURRENT_BINARY_DIR}/${_target}/GameObjectDBRegistrationDispatch.cpp")
    LIST(APPEND ${_output_files} "${CMAKE_CURRENT_BINARY_DIR}/${_target}/StringLiteralFermiStubDispatch.cu")
    LIST(APPEND ${_output_files} "${CMAKE_CURRENT_BINARY_DIR}/${_target}/StringLiteralStubDispatch.cpp")
    FILE(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${_target} )
    ADD_CUSTOM_COMMAND(
        OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/${_target}/CommonStubDispatch.cpp
        OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/${_target}/GameObjectDBRegistrationDispatch.cpp
        OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/${_target}/StringLiteralFermiStubDispatch.cu
        OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/${_target}/StringLiteralStubDispatch.cpp
        COMMAND ${ZCC_STUB_DISPATCH} -g ${__game_id_list} -p "${CMAKE_CURRENT_BINARY_DIR}/${_target}"
        DEPENDS ${ZCC_STUB_DISPATCH} ${_zs_files}
        COMMENT "Generate world server dispatch stub from " ${_zs_files}
        )
ENDMACRO()

# generates a zscript file using ALL string-literals found in zcc input
# always feed this zscript as the first file into zcc
# call this macro again to generate an "augmented" zscript file to be used as next zcc input 
MACRO(ZS2WS_STUB_STRING_TABLE)
    # parse the argument options
    set(__option_catalogries "OUTPUT_PATH;ZS_SRC_FILES;ZS_API_FILES;OUTPUT;DEPENDS")
    set(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set) 

    # check if the number of targets specified is wrong
    hashmap(GET __options_set "OUTPUT_PATH"  _target)
    hashmap(GET __options_set "ZS_SRC_FILES" __zs_src_files)
    hashmap(GET __options_set "ZS_API_FILES" __zs_api_files)
    hashmap(GET __options_set "OUTPUT"       __output)
    hashmap(GET __options_set "DEPENDS"      __depends)
    list(LENGTH __depends __number_of_depends)
    GET_FILENAME_COMPONENT(__zs_out_file_name ${__output} NAME)

    FILE(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${_target})
    SET(__default_stringtable_file "${CMAKE_CURRENT_BINARY_DIR}/${_target}/StringTableStub.zs")
    IF(__number_of_depends GREATER 0)
        IF(${__zs_out_file_name} STREQUAL "StringTableStub.zs")
            ADD_CUSTOM_COMMAND(
                OUTPUT  ${__output}
                COMMAND ${ZCC_WS} -t "${CMAKE_CURRENT_BINARY_DIR}/${_target}" ${__depends} ${__zs_src_files} ${__zs_api_files}
                DEPENDS ${ZCC_WS} ${__depends} ${__zs_src_files} ${__zs_api_files}
                COMMAND ${CMAKE_COMMAND} -E remove ${__depends}
                COMMENT "${__depends} ==> ${__output}"
                )
        ELSE()
            ADD_CUSTOM_COMMAND(
                OUTPUT  ${__output}
                COMMAND ${ZCC_WS} -t "${CMAKE_CURRENT_BINARY_DIR}/${_target}" ${__depends} ${__zs_src_files} ${__zs_api_files}
                COMMAND ${CMAKE_COMMAND} -E copy ${__default_stringtable_file} ${__output}
                COMMAND ${CMAKE_COMMAND} -E remove ${__default_stringtable_file}
                COMMAND ${CMAKE_COMMAND} -E remove ${__depends}
                DEPENDS ${ZCC_WS} ${__depends} ${__zs_src_files} ${__zs_api_files}
                COMMENT "${__depends} ==> ${__output}"
                )
        ENDIF()
    ELSE()
        ADD_CUSTOM_COMMAND(
            OUTPUT  ${__output}
            COMMAND ${ZCC_WS} -t "${CMAKE_CURRENT_BINARY_DIR}/${_target}" ${__zs_src_files} ${__zs_api_files}
            COMMAND ${CMAKE_COMMAND} -E copy ${__default_stringtable_file} ${__output}
            COMMAND ${CMAKE_COMMAND} -E remove ${__default_stringtable_file}
            DEPENDS ${ZCC_WS} ${__zs_src_files} ${__zs_api_files}
            COMMENT "==> ${__output}"
            )
    ENDIF()
ENDMACRO()

#
# compile zscript file to native library(to MT or FERMI)
#
#    According to ZCC_ARCH("cpu" or "gpu"), this macro will compile zscript to MT library of FERMI library
#
MACRO(ZS_2_NATIVE_CODE)

    # parse the argument options
    SET(__option_catalogries "TARGET_NAME;TARGET_TYPE;CPP_SRC_FILES;ZS_SRC_FILES;ZS_API_FILES;ZCC_ARCH;ZCC_OPTIONS")
    SET(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set)

    # check if the number of targets specified is wrong
    hashmap(GET __options_set "TARGET_NAME"   __target_name)
    hashmap(GET __options_set "TARGET_TYPE"   __target_type)
    hashmap(GET __options_set "CPP_SRC_FILES" __cpp_src_files)
    hashmap(GET __options_set "ZS_SRC_FILES"  __zs_src_files)
    hashmap(GET __options_set "ZS_API_FILES"  __zs_api_files)
    hashmap(GET __options_set "ZCC_ARCH"      __zcc_arch)
    hashmap(GET __options_set "ZCC_OPTIONS"   __zcc_options)

    foreach_make_absolute_path(__cpp_src_files)
    foreach_make_absolute_path(__zs_src_files)
    foreach_make_absolute_path(__zs_api_files)
    
    LIST(APPEND __zs_src_files ${__zs_api_files})
    
    STRING(TOLOWER ${__zcc_arch} __zcc_arch_tolower)
    IF(${__zcc_arch_tolower} STREQUAL "gpu")
        SET(ZCC_ARCH_GPU 1)
        LIST(APPEND __zcc_options "--arch" "gpu")
    ELSEIF(${__zcc_arch_tolower} STREQUAL "cpu")
        SET(ZCC_ARCH_CPU 1)
        LIST(APPEND __zcc_options "--arch" "cpu")
    ELSE()
        MESSAGE(FATAL_ERROR "MACRO: ZS_2_NATIVE_CODE. Unkown zcc arch. Please check it.")
    ENDIF()
    
    IF(NOT DEFINED __target_type)
        SET(__target_type "SHARED")
    ENDIF()

    ZS2OPT_ALL(
        __zs_all_file #output
        TARGET_NAME  ${__target_name}
        ZS_FILES     ${__zs_src_files}
        ZCC_ARCH     ${__zcc_arch}
        ZCC_OPTIONS  ${__zcc_options}
        )
        
    IF(${ZCC_ARCH_GPU} )

SET(ENABLE_EXT_FILTER "TRUE")
if(ENABLE_EXT_FILTER)
        LIST(APPEND __cpp_src_files ${__zs_all_file})

        SET( __split_cuda_src_files )
        SET( __split_cpp_src_files )
        FOREACH(arg ${__cpp_src_files})
            GET_FILENAME_COMPONENT(ARG_FILE_EXT ${arg} EXT)
            if((ARG_FILE_EXT STREQUAL ".cu") OR (ARG_FILE_EXT STREQUAL ".zsall.cu"))
                LIST(APPEND __split_cuda_src_files "${arg}")
            elseif((ARG_FILE_EXT STREQUAL ".cpp") OR (ARG_FILE_EXT STREQUAL ".zsall.c"))
                LIST(APPEND __split_cpp_src_files "${arg}")
            else()
                MESSAGE("FAIL TO DISPATCH: " ${arg})
            endif()
        ENDFOREACH()

        # build for fermi
        SET(__cuda_module_name ${__target_name}-cuda)
        #MESSAGE(STATUS "output: ${__split_cuda_src_files}")

        IF( ENABLE_FEATURE_CUDA )
        cuda_compile_ptx(ptxfiles ${__split_cuda_src_files} OPTIONS "-arch=${CUDA_SM_VERSION}")
        cuda_add_library(${__cuda_module_name} ${__split_cuda_src_files} ${ptxfiles} OPTIONS "-arch=${CUDA_SM_VERSION}" --compiler-options "-fPIC" --opencc-options "-OPT:Olimit=0")
        ENDIF()
        
        IF(${__target_type} STREQUAL "EXE")
            ADD_EXECUTABLE(${__target_name}
                ${__split_cpp_src_files}
                )
        ELSEIF(${__target_type} STREQUAL "SHARED")
            ADD_LIBRARY(${__target_name} SHARED
                ${__split_cpp_src_files}
                )
        ELSE()
            MESSAGE(ERROR "unknown target type for ZS_2_NATIVE_CODE macro")
        ENDIF()
        
        TARGET_LINK_LIBRARIES(${__target_name} ${__cuda_module_name})
else()
        # build for fermi
        SET(__cuda_module_name ${__target_name}-cuda)
        #MESSAGE(STATUS "output: ${__zs_all_file}")
        cuda_compile_ptx(ptxfiles ${__zs_all_file} OPTIONS "-arch=${CUDA_SM_VERSION}")
        cuda_add_library(${__cuda_module_name} ${__zs_all_file} ${ptxfiles} OPTIONS "-arch=${CUDA_SM_VERSION}" --compiler-options "-fPIC" --opencc-options "-OPT:Olimit=0")
        
        IF(${__target_type} STREQUAL "EXE")
            ADD_EXECUTABLE(${__target_name}
                ${__cpp_src_files}
                )
        ELSEIF(${__target_type} STREQUAL "SHARED")
            ADD_LIBRARY(${__target_name} SHARED
                ${__cpp_src_files}
                )
        ELSE()
            MESSAGE(ERROR "unknown target type for ZS_2_NATIVE_CODE macro")
        ENDIF()
        
        TARGET_LINK_LIBRARIES(${__target_name} ${__cuda_module_name})
endif()

    ELSEIF(${ZCC_ARCH_CPU})
        
        # build for mt
        IF(${__target_type} STREQUAL "EXE")
            ADD_EXECUTABLE(${__target_name} 
                ${__zs_all_file} ${__cpp_src_files}
                )
        ELSEIF(${__target_type} STREQUAL "SHARED")
            ADD_LIBRARY(${__target_name} SHARED 
                ${__zs_all_file} ${__cpp_src_files}
                )
        ELSE()
            MESSAGE(ERROR "unknown target type for ZS_2_NATIVE_CODE macro")
        ENDIF()
        
        #TARGET_LINK_LIBRARIES(${__target_name} WorldServerModule)
        
    ELSE()
        MESSAGE(FATAL_ERROR "MACRO: ZS_2_NATIVE_CODE. Unkown zcc arch (NOT CPU NOR GPU?). Please check it.")
    ENDIF()

ENDMACRO()

#
# Update zscript files to native code(.c or .cu)
#
#    Accroding to ZCC_ARCH("cpu" or "gpu"), this macro will generate .c or .cu files from zscript files.
#
#    @param __output_file Output file list that g++ or nvcc needs
#
MACRO(ZS2OPT_ALL __output_file)

    # parse the argument options
    SET(__option_catalogries "TARGET_NAME;ZS_FILES;ZCC_ARCH;ZCC_OPTIONS")
    SET(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set)

    # check if the number of targets specified is wrong
    hashmap(GET __options_set "TARGET_NAME"  __target_name)
    hashmap(GET __options_set "ZS_FILES"     __zs_files)
    hashmap(GET __options_set "ZCC_ARCH"     __zcc_arch)
    hashmap(GET __options_set "ZCC_OPTIONS"  __zcc_options)

	SET( _all_C  "${CMAKE_CURRENT_BINARY_DIR}/${__target_name}.zsall.c" )
	SET( _all_CU "${CMAKE_CURRENT_BINARY_DIR}/${__target_name}.zsall.cu" )
	SET( _output_OPT_BC "${CMAKE_CURRENT_BINARY_DIR}/${__target_name}.opt.bc" )
	SET( _output_ALL_BC "${CMAKE_CURRENT_BINARY_DIR}/${__target_name}.all.bc" )
    
    STRING(TOLOWER ${__zcc_arch} __zcc_arch_tolower)
    IF(${__zcc_arch_tolower} STREQUAL "gpu")
        # build for fermi        
        ADD_CUSTOM_COMMAND(
    	OUTPUT  ${_all_CU}
    	DEPENDS ${_output_OPT_BC} zillians-llc
    	COMMAND ${CMAKE_COMMAND} -E remove -f ${_all_CU}
    	COMMAND ${EXECUTABLE_OUTPUT_PATH}/zillians-llc ${_output_OPT_BC} -o ${_all_CU} -march=cu
        )
        LIST(APPEND ${__output_file} ${_all_CU})
    ELSEIF(${__zcc_arch_tolower} STREQUAL "cpu")
        # build for mt
        ADD_CUSTOM_COMMAND(
		OUTPUT  ${_all_C}
		DEPENDS ${_output_OPT_BC}
		COMMAND ${CMAKE_COMMAND} -E remove -f ${_all_C}
		COMMAND ${LLVM_BINDIR}/llc ${_output_OPT_BC} -o ${_all_C} -march="c"
        )
        LIST(APPEND ${__output_file} ${_all_C})
    ELSE()
        MESSAGE(FATAL_ERROR "MACRO: ZS2OPT_ALL. Unkown zcc target. Please check it.")
    ENDIF()
    
    ADD_CUSTOM_COMMAND(
		OUTPUT  ${_output_ALL_BC}
		DEPENDS ${__zs_files}
		DEPENDS ${ZCC_BC}
		COMMAND ${CMAKE_COMMAND} -E remove -f ${_output_ALL_BC}
		COMMAND ${ZCC_BC} ${__zcc_options} ${__zs_files} -o ${_output_ALL_BC}
        )
	ADD_CUSTOM_COMMAND(
		OUTPUT  ${_output_OPT_BC}
		DEPENDS ${_output_ALL_BC}
		#COMMAND ${LLVM_BINDIR}/opt -simplifycfg -live-values -instcombine -inline -globaldce -instcombine -simplifycfg -scalarrepl -mem2reg -verify -sccp -adce -licm -instcombine -dce -simplifycfg -deadargelim  -globaldce -deadtypeelim -ipconstprop -f ${_output_ALL_BC} -o ${_output_OPT_BC}
		COMMAND ${CMAKE_COMMAND} -E remove -f ${_output_OPT_BC}
		COMMAND ${LLVM_BINDIR}/opt -disable-opt -f ${_output_ALL_BC} -o ${_output_OPT_BC}
        )

ENDMACRO()
