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

execute_process(COMMAND ${TEST_PROG}
                OUTPUT_VARIABLE output_result
                ERROR_VARIABLE error_result
                RESULT_VARIABLE has_error)
if(has_error)
    message(FATAL_ERROR "test failed - nonzero error code returned")
endif()

string(REGEX MATCHALL ${PATTERN} matched_output_result ${output_result} ${error_result})
list(LENGTH matched_output_result length_of_matched_output_result)
if( (${MATCH_MODE} STREQUAL "match_for_failure") OR (${MATCH_MODE} STREQUAL "MATCH_FOR_FAILURE") )
    if(${length_of_matched_output_result} GREATER 0)
    #if( (${output_result} MATCHES ${PATTERN}) OR (${error_result} MATCHES ${PATTERN}) )
        message(FATAL_ERROR "test failed - failure pattern matched: ${matched_output_result}")
    endif()
elseif( (${MATCH_MODE} STREQUAL "match_for_success") OR (${MATCH_MODE} STREQUAL "MATCH_FOR_SUCCESS") )
    if(${length_of_matched_output_result} EQUAL 0)
    #if( NOT ((${output_result} MATCHES ${PATTERN}) OR (${error_result} MATCHES ${PATTERN})) )
        message(FATAL_ERROR "test failed - success pattern is not matched")
    endif()
else()
    message(FATAL_ERROR "unrecognize match mode: ${MATCH_MODE}")
endif()

