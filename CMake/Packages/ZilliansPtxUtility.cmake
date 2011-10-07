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

# ////////////////////////////////////////////////////////////////////////
# EXTRACT_PTX_ENTRY_POINT (no longer used)

# this macro exists to address a need for "C++ mangling/reverse-demangling"
# it relies on a parameter-less "hint" argument to resolve ptx entry points, therefore cannot resolve overloads
# ideally, the "hint" argument should include full function signature including parameters

# test implementation (fails when demangled name has non-trivial namespace)
MACRO(EXTRACT_PTX_ENTRY_POINT_V0 _out_ptx_entry_point ptx_file ptx_entry_point_hint)

    # get demangled name from hint
    EXECUTE_PROCESS(
        COMMAND cat ${ptx_file}
        COMMAND grep ".entry"                # extract all entry points from source
        COMMAND sed "s/ /:/g"                # WORKAROUND: CMake doesn't accept empty space argument
        COMMAND cut -d: -f2                  # extract mangled function name
        COMMAND xargs c++filt --no-params    # demangle mangled function name
        COMMAND grep ${ptx_entry_point_hint} # choose function from hint
        COMMAND tr -d "\n"                   # remove trailing line-feed
        OUTPUT_VARIABLE temp
        )
    SET(FN_DEMANGLED_NAME ${temp})

    # get mangled name from demangled name
    EXECUTE_PROCESS(
        COMMAND cat ${ptx_file}
        COMMAND grep ".entry"             # extract all entry points from source
        COMMAND sed "s/ /:/g"             # WORKAROUND: CMake doesn't accept empty space argument
        COMMAND cut -d: -f2               # extract mangled function name
        COMMAND grep ${FN_DEMANGLED_NAME} # choose function from demangled function name
        COMMAND tr -d "\n"                # remove trailing line-feed
        OUTPUT_VARIABLE temp
        )
    SET(${_out_ptx_entry_point} ${temp})

ENDMACRO()

MACRO(EXTRACT_PTX_ENTRY_POINT _out_ptx_entry_point ptx_file ptx_entry_point_hint)
    EXECUTE_PROCESS(
        COMMAND ${ZILLIANS_SCRIPT_PATH}/extract_ptx_entry_point.sh ${ptx_file} ${ptx_entry_point_hint}
        COMMAND tr -d "\n" # remove trailing line-feed
        OUTPUT_VARIABLE temp
        )
    SET(${_out_ptx_entry_point} ${temp})
ENDMACRO()

# ////////////////////////////////////////////////////////////////////////
# GENERATE_ENCRYPTED_PTX_HEADER

# this macro exists to help generate a header file with a string literal encrypted ptx defined as a macro
# ideally, it should not rely on an external bash script, and use CMAKE native commands instead

MACRO(GENERATE_ENCRYPTED_PTX_HEADER _target _ptx_file_header _ptx_file_stem _ptx_file _key_file _ptx_content_macro_name)
    SET(_ptx_file_bak ${_ptx_file_stem}.bak)
    SET(_ptx_file_encrypt ${_ptx_file_stem}.encrypt)
    SET(${_ptx_file_header} ${_ptx_file_stem}.encrypt.h)
    ADD_CUSTOM_COMMAND(
        DEPENDS ${_ptx_file}
        OUTPUT ${_ptx_file_encrypt}
        COMMAND ${CMAKE_COMMAND} -E copy ${_ptx_file} ${_ptx_file_bak} # NOTE: for diagnostics only
        COMMAND ${CMAKE_COMMAND} -E copy ${_ptx_file} ${_ptx_file_encrypt}
        COMMAND ${__location_ZILLIANS_CRYPTO_TOOL} ${_ptx_file_encrypt} --enc --hardware-key
        COMMAND ${__location_ZILLIANS_CRYPTO_TOOL} ${_ptx_file_encrypt} --enc --key-file ${_key_file} --base64
        )
    ADD_CUSTOM_COMMAND(
        DEPENDS ${_ptx_file_encrypt}
        OUTPUT ${${_ptx_file_header}}
        COMMAND ${ZILLIANS_SCRIPT_PATH}/generate_macrodef_header.sh ${_ptx_file_encrypt} ${${_ptx_file_header}} ${_ptx_content_macro_name}
        )
    ADD_CUSTOM_TARGET(${_target}_depends ALL
        DEPENDS ${${_ptx_file_header}}
        )
    ADD_DEPENDENCIES(${_target}
        ${_target}_depends
        )
ENDMACRO()
