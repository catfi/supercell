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

MACRO(THORPP_GEN)

    # parse the argument options
    SET(__option_catalogries "OUTPUT;INPUT;FROM_LANGUAGE;TO_LANGUAGE")
    SET(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set)

    # check if the number of targets specified is wrong
    hashmap(GET __options_set "OUTPUT" __output)
    hashmap(GET __options_set "INPUT" __input)
    hashmap(GET __options_set "FROM_LANGUAGE" __from_language)
    hashmap(GET __options_set "TO_LANGUAGE" __to_language)

    IF(DEFINED __input)

        GET_FILENAME_COMPONENT(__input_name ${__input} NAME)
        GET_FILENAME_COMPONENT(__input_ext ${__input} EXT)

        SET(SCRATCH_FILE "${CMAKE_CURRENT_BINARY_DIR}/${__input_name}")
        STRING(REGEX REPLACE ${__input_ext} "_generated_1.cpp" GEN_SOURCE_1 ${SCRATCH_FILE})
        STRING(REGEX REPLACE ${__input_ext} "_generated_2.cpp" GEN_SOURCE_2 ${SCRATCH_FILE})

        ADD_CUSTOM_COMMAND(
            COMMAND ${CMAKE_COMMAND} -E copy ${__input} ${SCRATCH_FILE}
            DEPENDS ${__input}
            OUTPUT ${SCRATCH_FILE}
            )

        set(cmd_string
            ${THORPP_PROGRAM} --input ${SCRATCH_FILE} --from ${__from_language} --to ${__to_language}
            )
        set(cmd_string
            ${CMAKE_COMMAND}
                -DCMD_STRING="${cmd_string}"
                -DWRITE_FILE="${GEN_SOURCE_1}"
                -P ${ZILLIANS_SCRIPT_PATH}/run_and_pipe_stdout_to_file.cmake
            )
        add_custom_command(
            COMMAND ${cmd_string}
            DEPENDS ${SCRATCH_FILE}
            OUTPUT ${GEN_SOURCE_1}
            )

        ADD_EXECUTABLE(GEN_PROGRAM_TARGET ${GEN_SOURCE_1})
        GET_TARGET_PROPERTY(GEN_PROGRAM GEN_PROGRAM_TARGET LOCATION)

        set(cmd_string
            ${CMAKE_COMMAND}
                -DCMD_STRING="${GEN_PROGRAM}"
                -DWRITE_FILE="${GEN_SOURCE_2}"
                -P ${ZILLIANS_SCRIPT_PATH}/run_and_pipe_stdout_to_file.cmake
            )
        add_custom_command(
            COMMAND ${cmd_string}
            DEPENDS ${GEN_SOURCE_1}
            OUTPUT ${GEN_SOURCE_2}
            )

        LIST(APPEND ${__output} ${GEN_SOURCE_2})

    ENDIF()

ENDMACRO()
