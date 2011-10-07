

macro( Antlr3TreeGrammar root_grammar tree_grammar out_hdr_files out_src_files )

	STRING( REGEX REPLACE ".*/" "" tree_grammar_name "${tree_grammar}" )
	STRING( REGEX REPLACE ".*/" "" root_grammar_name "${root_grammar}" )

	STRING( REGEX REPLACE "\\.g" ".cpp"	tree_grammar_cpp	"${tree_grammar_name}" )
	STRING( REGEX REPLACE "\\.g" ".c"	tree_grammar_c		"${tree_grammar_name}" )
	STRING( REGEX REPLACE "\\.g" ".h" 	tree_grammar_hdr	"${tree_grammar_name}" )
	STRING( REGEX REPLACE "\\.g" ".tokens" 	tree_grammar_tokens	"${tree_grammar_name}" )

	STRING( REGEX REPLACE "\\.g" "Lexer.c" 	root_grammar_lexer_c	"${root_grammar_name}" )
	STRING( REGEX REPLACE "\\.g" "Lexer.h" 	root_grammar_lexer_h	"${root_grammar_name}" )
	STRING( REGEX REPLACE "\\.g" "Parser.c" root_grammar_parser_c	"${root_grammar_name}" )
	STRING( REGEX REPLACE "\\.g" "Parser.h" root_grammar_parser_h	"${root_grammar_name}" )
	STRING( REGEX REPLACE "\\.g" ".tokens"	root_grammar_token	"${root_grammar_name}" )

	# Build the generated file and dependency file ##########################
	add_custom_command(
			OUTPUT	${CMAKE_CURRENT_BINARY_DIR}/${tree_grammar_cpp}
			OUTPUT	${CMAKE_CURRENT_BINARY_DIR}/${tree_grammar_hdr}
			OUTPUT	${CMAKE_CURRENT_BINARY_DIR}/${root_grammar_lexer_h}
			OUTPUT	${CMAKE_CURRENT_BINARY_DIR}/${root_grammar_lexer_cpp}
			OUTPUT	${CMAKE_CURRENT_BINARY_DIR}/${root_grammar_parser_h}
			OUTPUT	${CMAKE_CURRENT_BINARY_DIR}/${root_grammar_parser_cpp}
            DEPENDS ${root_grammar} ${tree_grammar}
			COMMAND ${CMAKE_COMMAND} -E copy ${root_grammar} ${CMAKE_CURRENT_BINARY_DIR}/
			COMMAND ${CMAKE_COMMAND} -E copy ${tree_grammar} ${CMAKE_CURRENT_BINARY_DIR}/
			COMMAND java -jar ${ANTLR3_COMMAND} -o ${CMAKE_CURRENT_BINARY_DIR}/ ${root_grammar}
			COMMAND java -jar ${ANTLR3_COMMAND} -o ${CMAKE_CURRENT_BINARY_DIR}/ ${tree_grammar}
			COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/${tree_grammar_c} ${CMAKE_CURRENT_BINARY_DIR}/${tree_grammar_cpp}
			)

	LIST( APPEND	${out_src_files}	"${CMAKE_CURRENT_BINARY_DIR}/${tree_grammar_cpp}" )
	LIST( APPEND	${out_hdr_files}	"${CMAKE_CURRENT_BINARY_DIR}/${tree_grammar_hdr}" )
	LIST( APPEND	${out_hdr_files}	"${CMAKE_CURRENT_BINARY_DIR}/${root_grammar_lexer_h}" )
	LIST( APPEND	${out_hdr_files}	"${CMAKE_CURRENT_BINARY_DIR}/${root_grammar_parser_h}" )

endmacro( Antlr3TreeGrammar ) 

macro( Antlr3RootGrammar root_grammar output_hdr_files  output_src_files )
	STRING( REGEX REPLACE ".*/" "" root_grammar_name "${root_grammar}" )

	STRING( REGEX REPLACE "\\.g" "Lexer.c" 	root_grammar_lexer_c	"${root_grammar_name}" )
	STRING( REGEX REPLACE "\\.g" "Parser.c" root_grammar_parser_c	"${root_grammar_name}" )
	STRING( REGEX REPLACE "\\.g" "Lexer.h" 	root_grammar_lexer_h	"${root_grammar_name}" )
	STRING( REGEX REPLACE "\\.g" "Parser.h" root_grammar_parser_h	"${root_grammar_name}" )
	STRING( REGEX REPLACE "\\.g" ".tokens"	root_grammar_token	"${root_grammar_name}" )

	# Build the generated file and dependency file ##########################
	add_custom_command(
			OUTPUT	${CMAKE_CURRENT_BINARY_DIR}/${root_grammar_lexer_h}
			OUTPUT	${CMAKE_CURRENT_BINARY_DIR}/${root_grammar_lexer_c}
			OUTPUT	${CMAKE_CURRENT_BINARY_DIR}/${root_grammar_parser_h}
			OUTPUT	${CMAKE_CURRENT_BINARY_DIR}/${root_grammar_parser_c}
			OUTPUT	${CMAKE_CURRENT_BINARY_DIR}/${root_grammar_token}
            DEPENDS ${root_grammar} 
			COMMAND ${CMAKE_COMMAND} -E copy ${root_grammar} ${CMAKE_CURRENT_BINARY_DIR}/
			COMMAND java -jar ${ANTLR3_COMMAND} -o ${CMAKE_CURRENT_BINARY_DIR}/ ${root_grammar}
			)

	LIST( APPEND	${output_hdr_files}	"${CMAKE_CURRENT_BINARY_DIR}/${root_grammar_lexer_h}" )
	LIST( APPEND	${output_hdr_files}	"${CMAKE_CURRENT_BINARY_DIR}/${root_grammar_parser_h}" )
	LIST( APPEND	${output_src_files}	"${CMAKE_CURRENT_BINARY_DIR}/${root_grammar_lexer_c}" )
	LIST( APPEND	${output_src_files}	"${CMAKE_CURRENT_BINARY_DIR}/${root_grammar_parser_c}" )

endmacro( Antlr3RootGrammar ) 

