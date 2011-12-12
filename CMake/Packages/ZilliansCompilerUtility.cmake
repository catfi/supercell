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

set(TSC_BINARY_PATH         ${CMAKE_CURRENT_BINARY_DIR}/compiler CACHE STRING "ThorScript Compiler Binary Path")

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
    set(oneValueArgs TARGET SOURCE BUNDLE_NAME OUTPUT)
    set(multiValueArgs "")

    cmake_parse_arguments(zillians_thorscript_create_bundle "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    add_custom_target(${zillians_thorscript_create_bundle_TARGET})
    add_dependencies(${zillians_thorscript_create_bundle_TARGET} tsc)
    
    # create temporary directory for creating bundle
    set(__ts_create_bundle_temporary_dir ${CMAKE_CURRENT_SOURCE_DIR}/create_bundle_temporary_dir)
    
    add_custom_command(
        TARGET ${zillians_thorscript_create_bundle_TARGET} PRE_BUILD
        # create the temporary directory for creaing bundle
        COMMAND ${CMAKE_COMMAND} -E make_directory ${__ts_create_bundle_temporary_dir}
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
        
endmacro()