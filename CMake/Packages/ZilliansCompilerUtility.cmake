#
# Zillians MMO
# Copyright (C) 2007-2011 Zillians.com, Inc.
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

set(TSC_BINARY_PATH         ${EXECUTABLE_OUTPUT_PATH}/compiler CACHE STRING "ThorScript Compiler Binary Path")
set(TSC_BUNDLE_PATH         ${EXECUTABLE_OUTPUT_PATH}/compiler/bundle CACHE STRING "ThorScript Compiler Bundle Path")

if(EXISTS ${TSC_BINARY_PATH})
    file(MAKE_DIRECTORY ${TSC_BINARY_PATH})
endif()

if(EXISTS ${TSC_BUNDLE_PATH})
    file(MAKE_DIRECTORY ${TSC_BUNDLE_PATH})
endif()

set(ThorScriptBundler       ${TSC_BINARY_PATH}/ts-bundle)
set(ThorScriptCompiler      ${TSC_BINARY_PATH}/ts-compile)
set(ThorScriptDep           ${TSC_BINARY_PATH}/ts-dep)
set(ThorScriptDriver        ${TSC_BINARY_PATH}/tsc)
set(ThorScriptLinker        ${TSC_BINARY_PATH}/ts-link)
set(ThorScriptMake          ${TSC_BINARY_PATH}/ts-make)
set(ThorScriptStrip         ${TSC_BINARY_PATH}/ts-strip)
set(ThorScriptStubGenerator ${TSC_BINARY_PATH}/ts-stub)
set(ThorScriptVM            ${TSC_BINARY_PATH}/ts-vm)

macro(zillians_thorscript_create_bundle)
    set(options "")
    set(oneValueArgs TARGET SOURCE BUNDLE_NAME OUTPUT_PATH)
    set(multiValueArgs "")

    cmake_parse_arguments(zillians_thorscript_create_bundle "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    add_custom_target(${zillians_thorscript_create_bundle_TARGET})
    add_dependencies(${zillians_thorscript_create_bundle_TARGET} tsc)
    
    # temporary directory for creating bundle
    set(__ts_create_bundle_temporary_dir ${CMAKE_CURRENT_BINARY_DIR}/create_bundle_temporary_dir)
    
    add_custom_command(
        TARGET ${zillians_thorscript_create_bundle_TARGET} PRE_BUILD
        # create the temporary directory for creaing bundle
        COMMAND ${CMAKE_COMMAND} -E make_directory ${__ts_create_bundle_temporary_dir}
        )
            
    add_custom_command(
        TARGET ${zillians_thorscript_create_bundle_TARGET} PRE_BUILD
        # remove existing build folder (if any) 
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${__ts_create_bundle_temporary_dir}/${zillians_thorscript_create_bundle_BUNDLE_NAME}
        # use tsc to generate project file
        COMMAND ${ThorScriptDriver} project create ${zillians_thorscript_create_bundle_BUNDLE_NAME}
        # copy all files under source folder to the temporary directory
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${zillians_thorscript_create_bundle_SOURCE} ${__ts_create_bundle_temporary_dir}/${zillians_thorscript_create_bundle_BUNDLE_NAME}/src
        WORKING_DIRECTORY ${__ts_create_bundle_temporary_dir} 
        )

    add_custom_command(
        TARGET ${zillians_thorscript_create_bundle_TARGET} PRE_BUILD
        # use tsc to generate all bundle file
        COMMAND ${ThorScriptDriver} build
        COMMAND ${ThorScriptDriver} generate bundle
        WORKING_DIRECTORY ${__ts_create_bundle_temporary_dir}/${zillians_thorscript_create_bundle_BUNDLE_NAME}
        )

    add_custom_command(
        TARGET ${zillians_thorscript_create_bundle_TARGET} PRE_BUILD
        # copy created bundle file into the output location
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${__ts_create_bundle_temporary_dir}/${zillians_thorscript_create_bundle_BUNDLE_NAME}/build/bin/${zillians_thorscript_create_bundle_BUNDLE_NAME}.bundle ${zillians_thorscript_create_bundle_OUTPUT_PATH}/${zillians_thorscript_create_bundle_BUNDLE_NAME}.bundle
        )
endmacro()

macro(zillians_thorscript_bundle_extract_ast)
    set(options "")
    set(oneValueArgs TARGET SOURCE_BUNDLE BUNDLE_NAME OUTPUT_PATH)
    set(multiValueArgs "")

    cmake_parse_arguments(zillians_thorscript_bundle_extract_ast "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    add_custom_target(${zillians_thorscript_bundle_extract_ast_TARGET})
    add_dependencies(${zillians_thorscript_bundle_extract_ast_TARGET} ts-bundle)

    # temporary directory for extracting ast from bundle
    set(zillians_thorscript_bundle_extract_ast_dir ${CMAKE_CURRENT_BINARY_DIR}/extract_ast_from_bundle)

    add_custom_command(TARGET ${zillians_thorscript_bundle_extract_ast_TARGET} PRE_BUILD
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${zillians_thorscript_bundle_extract_ast_dir}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${zillians_thorscript_bundle_extract_ast_dir}
        COMMAND ${ThorScriptBundler} -d ${zillians_thorscript_bundle_extract_ast_SOURCE_BUNDLE} --build-path=${zillians_thorscript_bundle_extract_ast_dir} 
        COMMAND ${CMAKE_COMMAND} -E copy ${zillians_thorscript_bundle_extract_ast_dir}/*/*.ast ${zillians_thorscript_bundle_extract_ast_OUTPUT_PATH}/${zillians_thorscript_bundle_extract_ast_BUNDLE_NAME}.ast
        )
endmacro()
