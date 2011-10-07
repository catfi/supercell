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

macro(list_replace list_variable index new_value)
	list(INSERT ${list_variable} ${index} ${new_value})
	math(EXPR __index "${index} + 1")
	list(REMOVE_AT ${list_variable} ${__index})
endmacro()

macro(__next_element_in_hashmap hashmap_variable current_index current_key current_length current_value next_index)
	#message("__next_element_in_hashmap: ${hashmap_variable} ${current_index} ${current_key} ${current_length} ${current_value} ${next_index} ")
	math(EXPR __key_index "${current_index} + 0")
	math(EXPR __header_index "${current_index} + 1")

	list(GET ${hashmap_variable} ${__key_index} __current_key)
	list(GET ${hashmap_variable} ${__header_index} __current_length)
	set(${current_key} ${__current_key})
	set(${current_length} ${__current_length})

	math(EXPR __start_index "${__header_index} + 1")
	math(EXPR __end_index "${__start_index} + ${__current_length} - 1")
	math(EXPR ${next_index} "${current_index} + ${__current_length} + 2")
	set(${current_value} "")
	#message("add into value: start_index = ${__start_index}, end_index = ${__end_index}")
	if(${__current_length} GREATER 0)
		foreach(__loop_index RANGE ${__start_index} ${__end_index} 1)
			#message("loop_index = ${__loop_index}")
			set(__temp "")
			list(GET ${hashmap_variable} ${__loop_index} __temp)
			#message("temp = ${__temp}")
			list(APPEND ${current_value} ${__temp})
			#message("current_value = ${current_value}, content = ${${current_value}}")
		endforeach()
	endif()
endmacro()

macro(__dump_hashmap hashmap_variable)
    #message("__dump_hashmap ${hashmap_variable}")
	list(LENGTH ${hashmap_variable} __length_of_hashmap)
    #message("dbg: __length_of_hashmap = ${___length_of_hashmap}")
	set(__current_index 0)
	while(__current_index LESS ${__length_of_hashmap})
		__next_element_in_hashmap(${hashmap_variable} ${__current_index} __current_key __current_length __current_value __next_index)
		#message("next: __current_key = ${__current_key}, __current_length = ${__current_length}, __current_value = ${__current_value}, __next_index = ${__next_index}")
		message("dump: hashmap variable = ${hashmap_variable}, key = ${__current_key}, value = ${__current_value}")
		set(__current_index ${__next_index})
		#message("cond: current_index = ${__current_index}, length_of_hashmap = ${__length_of_hashmap}")
	endwhile()
endmacro()

macro(__find_in_hashmap hashmap_variable key index value)
	#message("__find_in_hashmap: ${hashmap_variable} ${key} ${index} ${value}")
	list(LENGTH ${hashmap_variable} __length_of_hashmap)

    if(__length_of_hashmap EQUAL 0)
		set(${index} -1)
	else()
		set(__current_index 0)
		set(__found 0)
		while(__current_index LESS ${__length_of_hashmap})
			__next_element_in_hashmap(${hashmap_variable} ${__current_index} __current_key __current_length __current_value __next_index)
			#message("next: __current_key = ${__current_key}, __current_length = ${__current_length}, __current_value = ${__current_value}, __next_index = ${__next_index}")
			string(COMPARE EQUAL ${__current_key} ${key} __matched)
			if(__matched)
				#message("key found")
				set(${value} ${__current_value})
				set(${index} ${__current_index})
				set(__found 1)
				break()
			endif()
			set(__current_index ${__next_index})
			#message("cond: current_index = ${__current_index}, length_of_hashmap = ${__length_of_hashmap}")
		endwhile()

		if(NOT __found)
			set(${index} -1)
		endif()
	endif()
endmacro()

macro(__append_to_hashmap hashmap_variable key value)
	#message("__append_to_hashmap: ${hashmap_variable} ${key} ${value} (content = ${${value}})")
	list(APPEND ${hashmap_variable} ${key})
	list(LENGTH ${value} __length_of_value)
	list(APPEND ${hashmap_variable} ${__length_of_value})
	foreach(__element IN LISTS ${value})
		#message("inserting ${__element} to position ${index}")
		list(APPEND ${hashmap_variable} ${__element})
		#message("debug: hashmap_variable = ${hashmap_variable}, content = ${${hashmap_variable}}")
	endforeach()
endmacro()

macro(__remove_one_from_hashmap hashmap_variable index)
	list(GET ${hashmap_variable} ${index} __key)
	#message("removing one: key = ${__key}")
	list(REMOVE_AT ${hashmap_variable} ${index})

	list(GET ${hashmap_variable} ${index} __length_of_value)
	#message("removing one: length = ${__length_of_value}")
	list(REMOVE_AT ${hashmap_variable} ${index})

    if(__length_of_value GREATER 0)
    	foreach(__loop_index RANGE 1 ${__length_of_value} 1)
    		#message("removing one: remove ${__loop_index} item")
    		list(REMOVE_AT ${hashmap_variable} ${index})
    		#message("debug: hashmap_variable = ${hashmap_variable}, content = ${${hashmap_variable}}")
    	endforeach()
    endif()
endmacro()

macro(__put_into_hashmap hashmap_variable key value)
	#message("__put_into_hashmap: ${hashmap_variable} ${key} ${value} (content = ${${value}})")
	__find_in_hashmap(${hashmap_variable} ${key} __index __value)
	if(__index GREATER -1)
		#message("item with same key exists, remove it")
		__remove_one_from_hashmap(${hashmap_variable} ${__index})
	endif()
	__append_to_hashmap(${hashmap_variable} ${key} ${value})
endmacro()

macro(__get_from_hashmap hashmap_variable key value)
 	__find_in_hashmap(${hashmap_variable} ${key} __index __value)
    if(_index EQUAL -1)
		#message("key not found")
		set(${value} "")
	else()
		set(${value} ${__value})
    endif()
endmacro()

macro(__remove_from_hashmap hashmap_variable key)
	__find_in_hashmap(${hashmap_variable} ${key} __index __value)
	if(NOT (__index EQUAL -1) )
		__remove_one_from_hashmap(${hashmap_variable} ${__index})
	endif()
endmacro()


#
# hashmap Operations.
#
#   hashmap(PUT <hashmap> <key> <element>
#   hashmap(GET <hashmap> <key> <output variable>
#   hashmap(REMOVE <hashmap> <key>
#
macro(hashmap)
	if(${ARGV0} STREQUAL "PUT")
		# format: hashmap(PUT hashmap_variable key value(
		if(NOT (${ARGC} EQUAL 4) )
			message(FATAL_ERROR "wrong number of argument (ARGC = ${ARGC}, ARGN = ${ARGN}), correct form: hashmap(PUT hashmap_variable key value)")
		endif()
		
		#message("hashmap PUT: hashmap_variable => ${ARGV1}, key => ${ARGV2}, value => ${ARGV3}")

        if(DEFINED ${ARGV3})
			#message("set as ref")
			#set(__temp_variable_for_making_value_instance ${${ARGV3}})
        	__put_into_hashmap(${ARGV1} ${ARGV2} ${ARGV3})
        else()
			#message("set as val")
            set(__temp_variable_for_making_value_instance ${ARGV3})
	        __put_into_hashmap(${ARGV1} ${ARGV2} __temp_variable_for_making_value_instance)
        endif()
        

	elseif(${ARGV0} STREQUAL "GET")
		# format: hashmap(GET hashmap_variable key [out]value)
		if(NOT (${ARGC} EQUAL 4) )
			message(FATAL_ERROR "wrong number of argument (ARGC = ${ARGC}, ARGN = ${ARGN}), correct form: hashmap(GET hashmap_variable key value)")
		endif()

        __get_from_hashmap(${ARGV1} ${ARGV2} ${ARGV3})
        
	elseif(${ARGV0} STREQUAL "REMOVE")
		# format: hashmap(REMOVE hashmap_variable key)
		if(NOT (${ARGC} EQUAL 3) )
			message(FATAL_ERROR "wrong number of argument (ARGC = ${ARGC}, ARGN = ${ARGN}), correct form: hashmap(REMOVE hashmap_variable key value)")
		endif()

        __remove_from_hashmap(${ARGV1} ${ARGV2})
	elseif(${ARGV0} STREQUAL "CLEAR")
		# format: hashmap(CLEAR hashmap_variable)
		if(NOT (${ARGC} EQUAL 2) )
			message(FATAL_ERROR "wrong number of argument (ARGC = ${ARGC}, ARGN = ${ARGN}), correct form: hashmap(CLEAR hashmap_variable)")
		endif()

		set(${ARGV1} "")
		
	elseif(${ARGV0} STREQUAL "DUMP")
	    # format: hashmap(DUMP hashmap_variable)
	    
		if(NOT (${ARGC} EQUAL 2) )
			message(FATAL_ERROR "wrong number of argument (ARGC = ${ARGC}, ARGN = ${ARGN}), correct form: hashmap(CLEAR hashmap_variable)")
		endif()
	    
	    __dump_hashmap(${ARGV1})
	else()
	    message(FATAL_ERROR "unknown command ${ARGV0}")
	endif()

endmacro()
