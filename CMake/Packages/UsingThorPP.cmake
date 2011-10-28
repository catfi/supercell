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

SET(THORPP_LEGAL_EXT ".lp")

MACRO(GENERATE_STUB)

    ###################
    # PARSE ARGUMENTS #
    ###################

    # parse the argument options
    SET(__option_catalogries "OUTPUT_VARIABLE;INPUT;GEN_PATH;GEN_EXTENSION;FROM_LANGUAGE;TO_LANGUAGE")
    SET(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set)

    # check IF the number of targets specified is wrong
    hashmap(GET __options_set "OUTPUT_VARIABLE" __output_variable)
    hashmap(GET __options_set "INPUT"           __input_list)
    hashmap(GET __options_set "GEN_PATH"        __gen_path)
    hashmap(GET __options_set "GEN_EXTENSION"   __gen_extension)
    hashmap(GET __options_set "FROM_LANGUAGE"   __from_language)
    hashmap(GET __options_set "TO_LANGUAGE"     __to_language)

    ###################
    # CHECK ARGUMENTS #
    ###################

    IF(NOT DEFINED __input_list)
        MESSAGE(FATAL_ERROR "must specify input!")
    ENDIF()

    IF(NOT DEFINED __output_variable)
        MESSAGE(FATAL_ERROR "must specify output variable!")
    ENDIF()

    IF(NOT DEFINED __gen_path)
        MESSAGE(STATUS "no code-gen path specified -- generating to build path")
        SET(__gen_path "${CMAKE_CURRENT_BINARY_DIR}")
    ENDIF()

    IF(NOT DEFINED __gen_extension)
        MESSAGE(STATUS "no code-gen extension specified -- generating without extension")
    ENDIF()

    FOREACH(__input ${__input_list})

        ##############
        # INITIALIZE #
        ##############

        GET_FILENAME_COMPONENT(__input_name ${__input} NAME)
        GET_FILENAME_COMPONENT(__input_ext ${__input} EXT)

        IF(NOT ${__input_ext} STREQUAL ${THORPP_LEGAL_EXT})
            MESSAGE(FATAL_ERROR "unrecognized file extension!")
        ENDIF()

        IF(NOT EXISTS ${__input})
            MESSAGE(FATAL_ERROR "file must exist!")
        ENDIF()

        SET(__input_stem "${__gen_path}/${__input_name}") # do everything in code-gen path
        STRING(REGEX REPLACE ${__input_ext} "_generated_1.cpp"               gen_source_1 ${__input_stem})
        STRING(REGEX REPLACE ${__input_ext} "_generated_2${__gen_extension}" gen_source_2 ${__input_stem})

        ###########
        # DO WORK #
        ###########

        # generate INTERMEDIATE generator source
        SET(cmd_string
            ${THORPP_PROGRAM} --input ${__input} --from ${__from_language} --to ${__to_language}
            )
        SET(cmd_string
            ${CMAKE_COMMAND}
                -D__TEST_PROG="${cmd_string}"
                -D__OUTPUT_FILE="${gen_source_1}"
                -P ${ZILLIANS_SCRIPT_PATH}/run_and_pipe_stdout_to_file.cmake
            )
        ADD_CUSTOM_COMMAND(
            DEPENDS ${__input}
            COMMAND ${cmd_string}
            OUTPUT ${gen_source_1}
            COMMENT "UsingThorPP.cmake: generating INTERMEDIATE generator ${gen_source_2}"
            )

        # compile INTERMEDIATE generator
        ADD_EXECUTABLE(gen_program_1_target_${__input_name} ${gen_source_1})
        GET_TARGET_PROPERTY(gen_program_1 gen_program_1_target_${__input_name} LOCATION)

        # generate FINAL generator source
        SET(cmd_string
            ${CMAKE_COMMAND}
                -D__TEST_PROG="${gen_program_1}"
                -D__OUTPUT_FILE="${gen_source_2}"
                -P ${ZILLIANS_SCRIPT_PATH}/run_and_pipe_stdout_to_file.cmake
            )
        ADD_CUSTOM_COMMAND(
            DEPENDS ${gen_program_1}
            COMMAND ${cmd_string}
            COMMAND ${ZILLIANS_SCRIPT_PATH}/format_source.sh ${gen_source_2}    # BEAUTIFY OUTPUT
            COMMAND ${CMAKE_COMMAND} -E remove ${gen_program_1} ${gen_source_1} # CLEANUP
            OUTPUT ${gen_source_2}
            COMMENT "UsingThorPP.cmake: generating FINAL text ${gen_source_2}"
            )

        ##################
        # COLLECT OUTPUT #
        ##################

        # collect FINAL generator source
        IF(DEFINED __output_variable)
            LIST(APPEND ${__output_variable} ${gen_source_2})
        ENDIF()

    ENDFOREACH(__input)

ENDMACRO()
