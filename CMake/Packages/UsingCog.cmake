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

MACRO(zillians_add_cog_gen)

    # parse the argument options
    SET(__option_catalogries "OUTPUT_VARIABLE;INPUT")
    SET(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set)

    # check if the number of targets specified is wrong
    hashmap(GET __options_set "OUTPUT_VARIABLE" __output_variable)
    hashmap(GET __options_set "INPUT" __input)

    IF(DEFINED __input)

        STRING(REGEX REPLACE ".cog" ".h" OUTPUT_SOURCE_RENAMED ${__input})
        add_custom_command(
            OUTPUT ${OUTPUT_SOURCE_RENAMED}
            COMMAND ${COG_SCRIPT} -d -o ${OUTPUT_SOURCE_RENAMED} ${__input}
            DEPENDS ${__input}
            )
        LIST(APPEND ${__output_variable} ${OUTPUT_SOURCE_RENAMED})

    ENDIF()

ENDMACRO()
