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

INCLUDE_DIRECTORIES(
    ${PROJECT_COMMON_SOURCE_DIR}/include/
    ${PROJECT_FRAMEWORK_SOURCE_DIR}/include/
    )

SET(THORPP_EXTENSION ".lp")

MACRO(zillians_add_thorpp_gen)

    ###################
    # PARSE ARGUMENTS #
    ###################

    # parse the argument options
    SET(__option_catalogries "TARGET;OUTPUT_VARIABLE;INPUT;OUTPUT_PATH;OUTPUT_EXT")
    SET(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set)

    # check IF the number of targets specified is wrong
    hashmap(GET __options_set "TARGET"          __target)
    hashmap(GET __options_set "OUTPUT_VARIABLE" __output_variable)
    hashmap(GET __options_set "INPUT"           __input_list)
    hashmap(GET __options_set "OUTPUT_PATH"     __output_path)
    hashmap(GET __options_set "OUTPUT_EXT"      __output_ext)

    ###################
    # CHECK ARGUMENTS #
    ###################

    IF(NOT DEFINED __input_list)
        MESSAGE(FATAL_ERROR "must specify input!")
    ENDIF()

    IF(NOT DEFINED __target AND NOT DEFINED __output_variable)
        MESSAGE(FATAL_ERROR "must specify either target or output variable!")
    ENDIF()

    IF(NOT DEFINED __output_path)
        MESSAGE(STATUS "no output path specified -- generating to build path!")
        SET(__output_path "${CMAKE_CURRENT_BINARY_DIR}")
    ENDIF()

    IF(NOT DEFINED __output_ext)
        MESSAGE(STATUS "no output extension specified -- generating without extension!")
    ENDIF()

    IF(DEFINED __target)
        ADD_CUSTOM_TARGET(${__target}) # root target
    ENDIF()

    FOREACH(__input ${__input_list})

        ##############
        # INITIALIZE #
        ##############

        GET_FILENAME_COMPONENT(__input_name ${__input} NAME)
        GET_FILENAME_COMPONENT(__input_ext ${__input} EXT)

        IF(NOT ${__input_ext} STREQUAL ${THORPP_EXTENSION})
            MESSAGE(FATAL_ERROR "unrecognized file extension! ${__input_ext}")
        ENDIF()

        IF(NOT EXISTS ${__input})
            MESSAGE(FATAL_ERROR "file must exist!")
        ENDIF()

        SET(__input_stem "${__output_path}/${__input_name}") # do everything in output path
        STRING(REGEX REPLACE ${__input_ext} "${__output_ext}" gen_source_1 ${__input_stem})

        ###########
        # DO WORK #
        ###########

        # generate FINAL generator source
        SET(cmd_string
            ${THORPP_PROGRAM} --input ${__input} --from cpp --to cpp
            )
        SET(cmd_string
            ${CMAKE_COMMAND}
                -D__TEST_PROG="${cmd_string}"
                -D__OUTPUT_FILE="${gen_source_1}"
                -P ${ZILLIANS_SCRIPT_PATH}/run_and_pipe_stdout_to_file.cmake
            )
        IF(DEFINED __target)
            ADD_CUSTOM_TARGET(${__target}_${__input_name}
                DEPENDS ${__input}
                COMMAND ${cmd_string}
                COMMAND ${ZILLIANS_SCRIPT_PATH}/format_source.sh ${gen_source_1} # BEAUTIFY OUTPUT
                COMMENT "UsingThorPP.cmake: generating FINAL output ${gen_source_1}"
                ) # erect sub-target
            ADD_DEPENDENCIES(${__target} ${__target}_${__input_name}) # attach sub-target to root target
        ELSE()
            IF(DEFINED __output_variable)
                ADD_CUSTOM_COMMAND(
                    DEPENDS ${__input}
                    COMMAND ${cmd_string}
                    COMMAND ${ZILLIANS_SCRIPT_PATH}/format_source.sh ${gen_source_1} # BEAUTIFY OUTPUT
                    OUTPUT ${gen_source_1}
                    COMMENT "UsingThorPP.cmake: generating FINAL output ${gen_source_1}"
                    )
                LIST(APPEND ${__output_variable} ${gen_source_1}) # collect FINAL generator output
            ENDIF()
        ENDIF()

    ENDFOREACH(__input)

ENDMACRO()

MACRO(zillians_add_two_pass_thorpp_gen)

    ###################
    # PARSE ARGUMENTS #
    ###################

    # parse the argument options
    SET(__option_catalogries "TARGET;OUTPUT_VARIABLE;INPUT;OUTPUT_PATH;OUTPUT_EXT")
    SET(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set)

    # check IF the number of targets specified is wrong
    hashmap(GET __options_set "TARGET"          __target)
    hashmap(GET __options_set "OUTPUT_VARIABLE" __output_variable)
    hashmap(GET __options_set "INPUT"           __input_list)
    hashmap(GET __options_set "OUTPUT_PATH"     __output_path)
    hashmap(GET __options_set "OUTPUT_EXT"      __output_ext)

    ###################
    # CHECK ARGUMENTS #
    ###################

    IF(NOT DEFINED __input_list)
        MESSAGE(FATAL_ERROR "must specify input!")
    ENDIF()

    IF(NOT DEFINED __target AND NOT DEFINED __output_variable)
        MESSAGE(FATAL_ERROR "must specify either target or output variable!")
    ENDIF()

    IF(NOT DEFINED __output_path)
        MESSAGE(STATUS "no output path specified -- generating to build path!")
        SET(__output_path "${CMAKE_CURRENT_BINARY_DIR}")
    ENDIF()

    IF(NOT DEFINED __output_ext)
        MESSAGE(STATUS "no output extension specified -- generating without extension!")
    ENDIF()

    IF(DEFINED __target)
        ADD_CUSTOM_TARGET(${__target}) # root target
    ENDIF()

    FOREACH(__input ${__input_list})

        ##############
        # INITIALIZE #
        ##############

        GET_FILENAME_COMPONENT(__input_name ${__input} NAME)
        GET_FILENAME_COMPONENT(__input_ext ${__input} EXT)

        IF(NOT ${__input_ext} STREQUAL ${THORPP_EXTENSION})
            MESSAGE(FATAL_ERROR "unrecognized file extension! ${__input_ext}")
        ENDIF()

        IF(NOT EXISTS ${__input})
            MESSAGE(FATAL_ERROR "file must exist!")
        ENDIF()

        SET(__input_stem "${__output_path}/${__input_name}") # do everything in output path
        STRING(REGEX REPLACE ${__input_ext} "_intermediate.cpp" gen_source_1 ${__input_stem})
        STRING(REGEX REPLACE ${__input_ext} "${__output_ext}" gen_source_2 ${__input_stem})

        ###########
        # DO WORK #
        ###########

        # generate INTERMEDIATE generator source
        SET(cmd_string
            ${THORPP_PROGRAM} --input ${__input} --from cpp --to cpp
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
            COMMAND ${ZILLIANS_SCRIPT_PATH}/format_source.sh ${gen_source_1} # BEAUTIFY OUTPUT
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
        IF(DEFINED __target)
            ADD_CUSTOM_TARGET(${__target}_${__input_name}
                DEPENDS ${gen_program_1}
                COMMAND ${cmd_string}
                COMMAND ${ZILLIANS_SCRIPT_PATH}/format_source.sh ${gen_source_2}    # BEAUTIFY OUTPUT
                COMMAND ${CMAKE_COMMAND} -E remove ${gen_program_1} ${gen_source_1} # CLEANUP
                COMMENT "UsingThorPP.cmake: generating FINAL output ${gen_source_2}"
                ) # erect sub-target
            ADD_DEPENDENCIES(${__target} ${__target}_${__input_name}) # attach sub-target to root target
        ELSE()
            IF(DEFINED __output_variable)
                ADD_CUSTOM_COMMAND(
                    DEPENDS ${gen_program_1}
                    COMMAND ${cmd_string}
                    COMMAND ${ZILLIANS_SCRIPT_PATH}/format_source.sh ${gen_source_2}    # BEAUTIFY OUTPUT
                    COMMAND ${CMAKE_COMMAND} -E remove ${gen_program_1} ${gen_source_1} # CLEANUP
                    OUTPUT ${gen_source_2}
                    COMMENT "UsingThorPP.cmake: generating FINAL output ${gen_source_2}"
                    )
                LIST(APPEND ${__output_variable} ${gen_source_2}) # collect FINAL generator output
            ENDIF()
        ENDIF()

    ENDFOREACH(__input)

ENDMACRO()
