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

macro(zillians_register_game)
    # parse the argument options
    set(__option_catalogries "GAME_NAME;GAME_ID")
    set(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set) 
    
    # check if the number of targets specified is wrong
    hashmap(GET __options_set "GAME_NAME" __game_name)
    hashmap(GET __options_set "GAME_ID"   __game_id)
    list(LENGTH __game_name __number_of_game_name)
    list(LENGTH __game_id   __number_of_game_id)
    if(__number_of_game_name GREATER 1)
        message(FATAL_ERROR "can't register more than one game name!")
    endif()
    if(__number_of_game_id GREATER 1)
        message(FATAL_ERROR "can't register more than one game id!")
    endif()

    # register game
    set(${__game_name}_id ${__game_id})
endmacro()

macro(zillians_resolve_game_id __game_id __game_name)
    # resolve game id
    set(${__game_id} ${${__game_name}_id})
endmacro()
