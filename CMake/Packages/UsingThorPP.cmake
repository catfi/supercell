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

MACRO(GENERATE_STUB)

    ###################
    # PARSE ARGUMENTS #
    ###################

    # parse the argument options
    SET(__option_catalogries "TARGET;OUTPUT_VARIABLE;INPUT;FROM_LANGUAGE;TO_LANGUAGE")
    SET(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set)

    # check IF the number of targets specified is wrong
    hashmap(GET __options_set "TARGET" __target)
    hashmap(GET __options_set "OUTPUT_VARIABLE" __output_variable)
    hashmap(GET __options_set "INPUT" __input)
    hashmap(GET __options_set "FROM_LANGUAGE" __from_language)
    hashmap(GET __options_set "TO_LANGUAGE" __to_language)

    ###################
    # CHECK ARGUMENTS #
    ###################

    IF(NOT DEFINED __input)
        MESSAGE(FATAL_ERROR "must specify input!")
    ENDIF()

    IF(NOT EXISTS ${__input})
        MESSAGE(FATAL_ERROR "input must exist!")
    ENDIF()

    IF(NOT DEFINED __target AND NOT DEFINED __output_variable)
        MESSAGE(FATAL_ERROR "must specify either target or output variable!")
    ENDIF()

    IF(DEFINED __target AND DEFINED __output_variable)
        MESSAGE(FATAL_ERROR "can't specify both target and output variable!")
    ENDIF()

    LIST(LENGTH __target __number_of_target)
    IF(__number_of_target GREATER 1)
        MESSAGE(FATAL_ERROR "can't declare more than one target!")
    ENDIF()

    GET_FILENAME_COMPONENT(__input_name ${__input} NAME)
    GET_FILENAME_COMPONENT(__input_ext ${__input} EXT)

    IF(NOT ${__input_ext} MATCHES "lp")
        MESSAGE(FATAL_ERROR "unrecognized file extension!")
    ENDIF()

    ##############
    # INITIALIZE #
    ##############

    SET(__build_input "${CMAKE_CURRENT_BINARY_DIR}/${__input_name}")
    STRING(REGEX REPLACE ${__input_ext} "_generated_1.cpp" gen_source_1 ${__build_input})
    STRING(REGEX REPLACE ${__input_ext} "_generated_2.cpp" gen_source_2 ${__build_input})

    ###########
    # DO WORK #
    ###########

    # copy input to build path (do everything in build path)
    ADD_CUSTOM_COMMAND(
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${__input} ${__build_input}
        DEPENDS ${__input}
        OUTPUT ${__build_input}
        )

    # generate INTERMEDIATE generator source
    SET(cmd_string
        ${THORPP_PROGRAM} --input ${__build_input} --from ${__from_language} --to ${__to_language}
        )
    SET(cmd_string
        ${CMAKE_COMMAND}
            -D__TEST_PROG="${cmd_string}"
            -D__OUTPUT_FILE="${gen_source_1}"
            -P ${ZILLIANS_SCRIPT_PATH}/run_and_pipe_stdout_to_file.cmake
        )
    ADD_CUSTOM_COMMAND(
        COMMAND ${cmd_string}
        DEPENDS ${__build_input}
        OUTPUT ${gen_source_1}
        COMMENT "UsingThorPP.cmake: generating INTERMEDIATE generator ${gen_source_2}"
        )

    # compile INTERMEDIATE generator
    ADD_EXECUTABLE(gen_program_1_target ${gen_source_1})
    GET_TARGET_PROPERTY(gen_program_1 gen_program_1_target LOCATION)

    # generate FINAL generator source
    SET(cmd_string
        ${CMAKE_COMMAND}
            -D__TEST_PROG="${gen_program_1}"
            -D__OUTPUT_FILE="${gen_source_2}"
            -P ${ZILLIANS_SCRIPT_PATH}/run_and_pipe_stdout_to_file.cmake
        )
    ADD_CUSTOM_COMMAND(
        COMMAND ${cmd_string}
        DEPENDS ${gen_program_1}
        OUTPUT ${gen_source_2}
        COMMENT "UsingThorPP.cmake: generating FINAL generator ${gen_source_2}"
        )

    ##################
    # COLLECT OUTPUT #
    ##################

    # collect FINAL generator source
    IF(DEFINED __output_variable)
        LIST(APPEND ${__output_variable} ${gen_source_2})
    ENDIF()

    # compile FINAL generator and dump FINAL generator output to stdout (for debugging only!)
    IF(DEFINED __target)
        ADD_EXECUTABLE(gen_program_2_target ${gen_source_2})
        GET_TARGET_PROPERTY(gen_program_2 gen_program_2_target LOCATION)

        ADD_CUSTOM_TARGET(${__target} ALL)
        ADD_CUSTOM_COMMAND(
            TARGET ${__target}
            COMMAND ${gen_program_2}
            DEPENDS ${gen_program_2}
            COMMENT "UsingThorPP.cmake: generating FINAL output"
            )
    ENDIF()

ENDMACRO()
