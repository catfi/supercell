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

macro(zillians_create_test_subject)
    # parse the argument options
    set(__option_catalogries "SUBJECT")
    set(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set)
    
    # check if the number of subject names specified is wrong
    hashmap(GET __options_set "SUBJECT" __subject_name)
    list(LENGTH __subject_name __number_of_subject_names)
    if(__number_of_subject_names GREATER 1)
        message(FATAL_ERROR "can't declare more than one target!")
    endif()
    if(__number_of_subject_names EQUAL 0)
        message(FATAL_ERROR "no target declared!")
    endif()
     
    add_custom_target(testsubject-${__subject_name})
endmacro()

macro(zillians_add_custom_target_to_subject)
    # parse the argument options
    set(__option_catalogries "TARGET;SUBJECT")
    set(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set) 

    # check if the number of arguments specified is wrong
    hashmap(GET __options_set "TARGET" __target)
    list(LENGTH __target __number_of_target)
    if(__number_of_target GREATER 1)
        message(FATAL_ERROR "can't declare more than one target!")
    endif()
    if(__number_of_target EQUAL 0)
        message(FATAL_ERROR "no target declared!")
    endif()
    
    hashmap(GET __options_set "SUBJECT" __subject_name)
    list(LENGTH __subject_name __number_of_subject_names)
    if(__number_of_subject_names GREATER 1)
        message(FATAL_ERROR "can't declare more than one target!")
    endif()
    if(__number_of_subject_names EQUAL 0)
        message(FATAL_ERROR "no target declared!")
    endif()

    add_dependencies(testsubject-${__subject_name} ${__target})
endmacro()

macro(zillians_add_test_to_subject)
    # parse the argument options
    set(__option_catalogries "TARGET;SUBJECT")
    set(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set) 

    # check if the number of arguments specified is wrong
    hashmap(GET __options_set "TARGET" __target)
    list(LENGTH __target __number_of_target)
    if(__number_of_target GREATER 1)
        message(FATAL_ERROR "can't declare more than one target!")
    endif()
    if(__number_of_target EQUAL 0)
        message(FATAL_ERROR "no target declared!")
    endif()
    
    hashmap(GET __options_set "SUBJECT" __subject_name)
    list(LENGTH __subject_name __number_of_subject_names)
    if(__number_of_subject_names GREATER 1)
        message(FATAL_ERROR "can't declare more than one target!")
    endif()
    if(__number_of_subject_names EQUAL 0)
        message(FATAL_ERROR "no target declared!")
    endif()

    add_dependencies(testsubject-${__subject_name} runtest-${__target})
endmacro()

macro(zillians_add_subject_to_subject)
    # parse the argument options
    set(__option_catalogries "PARENT;CHILD")
    set(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set) 

    # check if the number of arguments specified is wrong
    hashmap(GET __options_set "PARENT" __subject_parent)
    list(LENGTH __target __number_of___subject_parent)
    if(__number_of_targets GREATER 1)
        message(FATAL_ERROR "can't declare more than one target!")
    endif()
    if(__number_of_targets EQUAL 0)
        message(FATAL_ERROR "no target declared!")
    endif()
    
    hashmap(GET __options_set "CHILD" __subject_child)
    list(LENGTH __subject_child __number_of_subject_child)
    if(__number_of_subject_child GREATER 1)
        message(FATAL_ERROR "can't declare more than one target!")
    endif()
    if(__number_of_subject_child EQUAL 0)
        message(FATAL_ERROR "no target declared!")
    endif()

    add_dependencies(testsubject-${__subject_parent} testsubject-${__subject_child})
endmacro()

#
# Add simple test case (which just executes the target executable and determine failed or success depending on the execution return value)
# 
macro(zillians_add_simple_test)
    # parse the argument options
    set(__option_catalogries "TARGET")
    set(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set) 
    
    # check if the number of targets specified is wrong
    hashmap(GET __options_set "TARGET" __target)
    list(LENGTH __target __number_of_targets)
    if(__number_of_targets GREATER 1)
        message(FATAL_ERROR "can't declare more than one target!")
    endif()
    if(__number_of_targets EQUAL 0)
        message(FATAL_ERROR "no target declared!")
    endif()
    
    # get the target location
    get_target_property(__location_${__target} ${__target} LOCATION)
    
    # create test targets and set dependencies
    add_test(NAME runtest-${__target} COMMAND ${CMAKE_COMMAND} -DTEST_PROG:STRING=${__location_${__target}} -P ${ZILLIANS_SCRIPT_PATH}/run.cmake)
    add_custom_target(runtest-${__target} DEPENDS ${__target} COMMAND ${CMAKE_COMMAND} -DTEST_PROG:STRING=${__location_${__target}} -P ${ZILLIANS_SCRIPT_PATH}/run.cmake)
    add_dependencies(check runtest-${__target})

endmacro()

macro(zillians_add_complex_test)
    # parse the argument options
    set(__option_catalogries "TARGET;SHELL;DEPENDS;EXPECT_FAIL")
    set(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set) 
    
    # check if the number of targets specified is wrong
    hashmap(GET __options_set "TARGET" __target)
    hashmap(GET __options_set "SHELL" __shell)
    hashmap(GET __options_set "DEPENDS" __depends)
    hashmap(GET __options_set "EXPECT_FAIL" __expect_fail)
    list(LENGTH __target __number_of_targets)
    list(LENGTH __shell __number_of_shell)
    list(LENGTH __depends __number_of_depends)
    if(__number_of_targets GREATER 1)
        message(FATAL_ERROR "can't declare more than one target!")
    endif()
    if(__number_of_targets EQUAL 0)
        message(FATAL_ERROR "no target declared!")
    endif()
    if(__number_of_shell EQUAL 0)
        message(FATAL_ERROR "no shell declared!")
    endif()
    
    set( cmd_string )
    foreach( cmd ${__shell} )
        set( cmd_string ${cmd_string} ${cmd} )
    endforeach( cmd )
    
    # create test targets and set dependencies
    add_test(NAME runtest-${__target} COMMAND ${CMAKE_COMMAND} -DTEST_PROG:STRING="${__shell}" -P ${ZILLIANS_SCRIPT_PATH}/run.cmake)
    if( __expect_fail )
        set( cmd_string ${CMAKE_COMMAND} -DTEST_PROG:STRING="${cmd_string}" -DEXPECT_FAIL="TRUE" -P ${ZILLIANS_SCRIPT_PATH}/run.cmake )
    else()
        set( cmd_string ${CMAKE_COMMAND} -DTEST_PROG:STRING="${cmd_string}" -P ${ZILLIANS_SCRIPT_PATH}/run.cmake )
    endif()
    if( __number_of_depends EQUAL 0 )
        add_custom_target(runtest-${__target} COMMAND ${cmd_string} )
    else()
        add_custom_target(runtest-${__target} DEPENDS ${__depends} COMMAND ${cmd_string} )
    endif()
    if(TARGET ${__target})
        add_dependencies(runtest-${__target} ${__target})
    endif()
    add_dependencies(check runtest-${__target})

endmacro()

#
# Add "regex-match-output" test case (which executes the target executable and try to match the given pattern to the program output)
# 
macro(zillians_add_regex_match_output_test)
    # parse the argument options
    set(__option_catalogries "TARGET;PATTERN;MODE")
    set(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set) 
    
    # check if the number of targets specified is wrong
    hashmap(GET __options_set "TARGET" __target)
    list(LENGTH __target __number_of_targets)
    if(__number_of_targets GREATER 1)
        message(FATAL_ERROR "can't declare more than one target!")
    endif()
    if(__number_of_targets EQUAL 0)
        message(FATAL_ERROR "no target declared!")
    endif()
    
    # check if it's valid pattern
    hashmap(GET __options_set "PATTERN" __pattern)
    
    # check if the mode is correct
    hashmap(GET __options_set "MODE" __mode)
    
    # get the target location
    get_target_property(__location_${__target} ${__target} LOCATION)
    
    # create test targets and set dependencies
    add_test(NAME runtest-${__target} COMMAND ${CMAKE_COMMAND} -DTEST_PROG:STRING=${__location_${__target}} -DPATTERN=${__pattern} -DMATCH_MODE=${__mode} -P ${ZILLIANS_SCRIPT_PATH}/run_and_match.cmake)
    add_custom_target(runtest-${__target} DEPENDS ${__target} COMMAND ${CMAKE_COMMAND} -DTEST_PROG:STRING=${__location_${__target}} -DPATTERN=${__pattern} -DMATCH_TYPE=${__mode} -P ${ZILLIANS_SCRIPT_PATH}/run_and_match.cmake)
    add_dependencies(check runtest-${__target})

endmacro()

#
# Add "compare-output" test case (which executes the target executable and try to compare the program output to the expected output)
# 
macro(zillians_add_compare_output_test target_name expected_output)
    # parse the argument options
    set(__option_catalogries "TARGET;EXPECT")
    set(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set) 
    
    # check if the number of targets specified is wrong
    hashmap(GET __options_set "TARGET" __target)
    list(LENGTH __target __number_of_targets)
    if(__number_of_targets GREATER 1)
        message(FATAL_ERROR "can't declare more than one target!")
    endif()
    if(__number_of_targets EQUAL 0)
        message(FATAL_ERROR "no target declared!")
    endif()
    
    # check if an expected output is given 
    hashmap(GET __options_set "EXPECT" __expect)
    
    # get the target location
    get_target_property(__location_${__target} ${__target} LOCATION)
    
    if(IS_ABSOLUTE "${__expect}")
        set(__expected_output ${__expect})
    else()
        set(__expected_output "${CMAKE_CURRENT_SOURCE_DIR}/${__expect}")
    endif()
    
    # create test targets and set dependencies
    add_test(NAME runtest-${__target} COMMAND ${CMAKE_COMMAND} -DTEST_PROG:STRING=${__location_${__target}} -DOUTPUT_LOCATION="/tmp/output.txt" -DEXPECTED_OUTPUT=${__expected_output} -P ${ZILLIANS_SCRIPT_PATH}/run_and_compare.cmake)
    add_custom_target(runtest-${__target} DEPENDS ${__target} COMMAND ${CMAKE_COMMAND} -DTEST_PROG:STRING=${__location_${__target}} -DOUTPUT_LOCATION="/tmp/output.txt" -DEXPECTED_OUTPUT=${__expected_output} -P ${ZILLIANS_SCRIPT_PATH}/run_and_compare.cmake)
    add_dependencies(check runtest-${__target})

endmacro()
