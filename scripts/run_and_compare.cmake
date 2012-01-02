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
                OUTPUT_FILE ${OUTPUT_LOCATION}
                RESULT_VARIABLE has_error)
if(has_error)
    message(FATAL_ERROR "test failed - nonzero error code returned")
endif()

execute_process(COMMAND ${CMAKE_COMMAND} -E compare_files
    ${OUTPUT_LOCATION} ${EXPECTED_OUTPUT}
    RESULT_VARIABLE compare_result)
if(compare_result)
    if(NOT WIN32)
        execute_process(COMMAND diff -y ${OUTPUT_LOCATION} ${EXPECTED_OUTPUT})
    endif() 
    message(FATAL_ERROR "test failed - files differ")
endif()