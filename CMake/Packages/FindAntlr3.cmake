MESSAGE(STATUS "Looking for ANTLR...")

SET( ANTLR3_FOUND 0 CACHE BOOL "Please install antlr library?" )

FIND_PATH(ANTLR3_INCLUDE_DIR antlr3.h /usr/local/include/ /usr/include /opt/antlr/include /usr64/include)

IF(WIN32)
FIND_PATH(ANTLR3_STATIC_LIB_DIR antlr3c.lib /usr64/lib /usr/local/lib /usr/lib /opt/antlr/lib)
ELSE(WIN32)
FIND_PATH(ANTLR3_STATIC_LIB_DIR libantlr3c.a /usr/local/lib /usr/lib /opt/antlr/lib)
ENDIF(WIN32)

FIND_PROGRAM(ANTLR3_COMPILER_JAR antlr-3.2.jar ${CMAKE_SOURCE_DIR}/dep/java/antlr3/ /usr/bin /opt/antlr/bin)

IF ( ANTLR3_INCLUDE_DIR)
    SET( ANTLR3_FOUND 1 CACHE BOOL "Please install antlr library?" FORCE )
    SET( ANTLR3_INCLUDES ${ANTLR3_INCLUDE_DIR} )
ENDIF( ANTLR3_INCLUDE_DIR )

IF(ANTLR3_FOUND)
    IF(NOT ANTLR3_STATIC_LIB_DIR)
        SET( ANTLR3_FOUND 1 CACHE BOOL "Please install antlr library?" FORCE )
    ELSE ()
		IF(WIN32)
			SET( ANTLR3_STATIC_LIB ${ANTLR3_STATIC_LIB_DIR}/antlr3c.lib )
		ELSE(WIN32)
			SET( ANTLR3_STATIC_LIB ${ANTLR3_STATIC_LIB_DIR}/libantlr3c.a )
		ENDIF(WIN32)
    ENDIF(NOT ANTLR3_STATIC_LIB_DIR)
ENDIF(ANTLR3_FOUND)

IF(ANTLR3_FOUND)
    IF(NOT ANTLR3_COMPILER_JAR)
        SET( ANTLR3_FOUND 0 CACHE BOOL "Please install antlr library?" FORCE )
    ELSE ()
        SET( ANTLR3_COMMAND "${ANTLR3_COMPILER_JAR}" )
    ENDIF(NOT ANTLR3_COMPILER_JAR)
ENDIF(ANTLR3_FOUND)

#message( " antrl3 ${ANTLR3_STATIC_LIB} " )

macro( ANTLR3_TREE_GRAMMAR_ADD _src_fn _tree_fn)
	STRING( REGEX REPLACE "\\.g" ".cpp" _output_file "${_src_fn}" )
	STRING( REGEX REPLACE "\\.g" ".c" _output_tmp_file "${_src_fn}" )
	STRING( REGEX REPLACE "\\.g" ".h" _output_hdr_file "${_src_fn}" )
	STRING( REGEX REPLACE "\\.g" ".tokens" _tok_file "${_tree_fn}" )

	# Build the generated file and dependency file ##########################
	add_custom_command(
			OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${_output_file}
			DEPENDS  ${CMAKE_CURRENT_SOURCE_DIR}/${_src_fn}
			DEPENDS  ${CMAKE_CURRENT_BINARY_DIR}/${_tok_file}
			#COMMAND ${ANTLR3_OS_COPY} \"${CMAKE_CURRENT_SOURCE_DIR}/${_src_fn}\" \"${CMAKE_CURRENT_BINARY_DIR}/\"
			COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/${_src_fn} ${CMAKE_CURRENT_BINARY_DIR}/
			COMMAND java -jar ${ANTLR3_COMMAND} -o ${CMAKE_CURRENT_BINARY_DIR}/ ${CMAKE_CURRENT_BINARY_DIR}/${_src_fn}
			COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/${_output_tmp_file} ${CMAKE_CURRENT_BINARY_DIR}/${_output_file}
			COMMAND ${CMAKE_COMMAND} -E make_directory ${LIBRARY_OUTPUT_PATH}/include/
			COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/${_output_hdr_file} ${LIBRARY_OUTPUT_PATH}/include/
			)

endmacro( ANTLR3_TREE_GRAMMAR_ADD ) 

macro( ANTLR3_GRAMMAR_ADD _src_fn )
	STRING( REGEX REPLACE "\\.g" "Lexer.c" _lxr_output_file "${_src_fn}" )
	STRING( REGEX REPLACE "\\.g" "Parser.c" _psr_output_file "${_src_fn}" )
	STRING( REGEX REPLACE "\\.g" "Lexer.h" _lxr_output_hdr_file "${_src_fn}" )
	STRING( REGEX REPLACE "\\.g" "Parser.h" _psr_output_hdr_file "${_src_fn}" )
	STRING( REGEX REPLACE "\\.g" ".tokens" _tok_output_file "${_src_fn}" )

	# Build the generated file and dependency file ##########################
	add_custom_command(
			OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${_lxr_output_file} ${CMAKE_CURRENT_BINARY_DIR}/${_psr_output_file} 
			OUTPUT ${LIBRARY_OUTPUT_PATH}/include/${_output_hdr_file}
			OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${_tok_output_file}
			OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${_psr_output_file}
			OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${_lxr_output_file}
			DEPENDS  ${CMAKE_CURRENT_SOURCE_DIR}/${_src_fn}
			COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/${_src_fn} ${CMAKE_CURRENT_BINARY_DIR}/
			COMMAND java -jar ${ANTLR3_COMMAND} -o ${CMAKE_CURRENT_BINARY_DIR}/ ${CMAKE_CURRENT_BINARY_DIR}/${_src_fn}
			COMMAND ${CMAKE_COMMAND} -E make_directory ${LIBRARY_OUTPUT_PATH}/include/
			COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/${_lxr_output_hdr_file} ${LIBRARY_OUTPUT_PATH}/include/
			COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/${_psr_output_hdr_file} ${LIBRARY_OUTPUT_PATH}/include/
			)
endmacro( ANTLR3_GRAMMAR_ADD ) 
