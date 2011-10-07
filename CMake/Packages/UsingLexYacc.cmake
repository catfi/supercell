#
# Zillians MMO
# Copyright (C) 2007-2010 Zillians.com, Inc.
# For more information see http:#www.zillians.com
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

MACRO(LEXYACC_GEN)

    # parse the argument options
    SET(__option_catalogries "OUTPUT;YACC_FILE;LEX_FILE")
    SET(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set)

    # check if the number of targets specified is wrong
    hashmap(GET __options_set "OUTPUT"    __output)
    hashmap(GET __options_set "YACC_FILE" __yacc_file)
    hashmap(GET __options_set "LEX_FILE"  __lex_file)

    IF(DEFINED __yacc_file)

        GET_FILENAME_COMPONENT(YACC_STEM ${__yacc_file} NAME_WE)
        set(PARSER "${YACC_STEM}_Parser")
        BISON_TARGET(${PARSER}
            ${__yacc_file}
            ${CMAKE_CURRENT_BINARY_DIR}/${YACC_STEM}.tab.c
            )
        STRING(REGEX REPLACE "${YACC_STEM}.tab.c" "${YACC_STEM}.tab.cpp" BISON_${PARSER}_OUTPUT_SOURCE_RENAMED ${BISON_${PARSER}_OUTPUT_SOURCE})
        add_custom_command(
            OUTPUT ${BISON_${PARSER}_OUTPUT_SOURCE_RENAMED}
            COMMAND ${CMAKE_COMMAND} -E rename ${BISON_${PARSER}_OUTPUT_SOURCE} ${BISON_${PARSER}_OUTPUT_SOURCE_RENAMED}
            DEPENDS ${BISON_${PARSER}_OUTPUT_SOURCE}
            )
        LIST(APPEND ${__output} ${BISON_${PARSER}_OUTPUT_SOURCE_RENAMED})

        IF(DEFINED __lex_file)

            GET_FILENAME_COMPONENT(LEX_STEM ${__yacc_file} NAME_WE)
            set(SCANNER "${LEX_STEM}_Scanner")
            FLEX_TARGET(${SCANNER}
                ${__lex_file}
                ${CMAKE_CURRENT_BINARY_DIR}/lex.${LEX_STEM}.c
                )
            ADD_FLEX_BISON_DEPENDENCY(
                ${SCANNER}
                ${PARSER}
                ) # NOTE: not sure what it means
            STRING(REGEX REPLACE
                "${CMAKE_CURRENT_BINARY_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}" FLEX_${SCANNER}_OUTPUTS_MISPLACED ${FLEX_${SCANNER}_OUTPUTS}
                ) # NOTE: workaround for flex bug -- flex ignores command line arg "-o", instead uses "pwd"
            STRING(REGEX REPLACE "lex.${LEX_STEM}.c" "lex.${LEX_STEM}.cpp" FLEX_${SCANNER}_OUTPUTS_RENAMED ${FLEX_${SCANNER}_OUTPUTS})
            add_custom_command(
                OUTPUT ${FLEX_${SCANNER}_OUTPUTS_RENAMED}
                COMMAND ${CMAKE_COMMAND} -E rename ${FLEX_${SCANNER}_OUTPUTS_MISPLACED} ${FLEX_${SCANNER}_OUTPUTS_RENAMED}
                DEPENDS ${FLEX_${SCANNER}_OUTPUTS}
                )
            LIST(APPEND ${__output} ${FLEX_${SCANNER}_OUTPUTS_RENAMED})

        ENDIF()

    ENDIF()

ENDMACRO()
