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

# Convert all files in the file list into files with absolute path  
macro(foreach_make_absolute_path __list_of_files)
    #message(STATUS "before making absolute: ${${__list_of_files}}")
    set(__list_of_absolute_files "")
    foreach(__file_in_list IN LISTS ${__list_of_files})
        #message(STATUS "foreach ${__file_in_list}")
        if(IS_ABSOLUTE ${__file})
            list(APPEND __list_of_absolute_files ${__file_in_list})
        else()
            #get_filename_component(__xxx ${__file_in_list} ABSOLUTE)
            #set(__abs_file_in_list "${CMAKE_CURRENT_SOURCE_DIR}/${__file_in_list}")
            get_filename_component(__abs_file_in_list ${__file_in_list} ABSOLUTE)
            list(APPEND __list_of_absolute_files ${__abs_file_in_list})
            #message(STATUS "appending: ${__list_of_absolute_files}")
        endif()
    endforeach()
    #message(STATUS "after appending: ${__list_of_absolute_files}")
    set(${__list_of_files} ${__list_of_absolute_files})
    #message(STATUS "after making absolute: ${${__list_of_files}}")
endmacro()