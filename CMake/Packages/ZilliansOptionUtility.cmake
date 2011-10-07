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

#
# Split list of arguments into seperate list stored in a hashmap
#
macro(split_options options default_catagory catagories option_sets)
    #message("split_options: ${options} ${catagories} ${option_sets}")
    set(__default_option_list "")
    hashmap(CLEAR ${option_sets})
    foreach(__catalog IN LISTS ${catagories})
        #message("split_options: catalog found \"${__catalog}\"")
        hashmap(PUT ${option_sets} ${__catalog} "")
    endforeach()
    
    set(__current_catalog ${default_catagory})
    foreach(__option IN LISTS ${options})
        list(FIND ${catagories} ${__option} __catalog_index)
        if(NOT (__catalog_index EQUAL -1) )
            list(GET ${catagories} ${__catalog_index} __current_catalog)
        else()        
            if(__current_catalog STREQUAL ${default_catagory})
                list(APPEND __default_option_list ${__option})
            else()
                #message("updating option list for ${__current_catalog}")
                set(__current_option_list "")
                hashmap(GET ${option_sets} ${__current_catalog} __current_option_list)
                list(APPEND __current_option_list ${__option})
                hashmap(PUT ${option_sets} ${__current_catalog} __current_option_list)
            endif()
        endif()
    endforeach()
    
    #message("__default_option_list = ${__default_option_list}")
    if(NOT (__default_option_list STREQUAL "") )
        hashmap(PUT ${option_sets} ${default_catagory} __default_option_list)
    endif()
endmacro()