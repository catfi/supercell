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
# this macro is used to translate buffer definition (xml) into cpp header file
#
macro(zillians_compile_buffer target_name config_file generated_file)

    # make sure the config_file points to an absolute path
    if(IS_ABSOLUTE "${config_file}")
        set(_config_file "${config_file}")
    else()
        set(_config_file "${CMAKE_CURRENT_SOURCE_DIR}/${config_file}")
    endif()

    # make sure the generated_file points to an absolute path
    if(IS_ABSOLUTE "${generated_file}")
        set(_generated_file "${generated_file}")
    else()
        set(_generated_file "${CMAKE_CURRENT_SOURCE_DIR}/${generated_file}")
    endif()

    if(TARGET zillians-buffer-generator)
        # if the zillians-buffer-generator is built
        # create the custom target to generate buffer definition by using zillians-buffer-generator
        get_target_property(__location_zillians-buffer-generator zillians-buffer-generator LOCATION)
        add_custom_command(
            #OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${target_name}_generated.h
            OUTPUT ${_generated_file}
            DEPENDS ${__location_zillians-buffer-generator} ${_config_file} 
            MAIN_DEPENDENCY ${_config_file}
            # tricky: generate a colored message by using triple back-slash as escape character
            COMMAND ${__location_zillians-buffer-generator} -c ${_config_file} -o ${CMAKE_CURRENT_BINARY_DIR}/${target_name}_generated.h
            COMMAND ${ZILLIANS_SCRIPT_PATH}/format_source.sh ${CMAKE_CURRENT_BINARY_DIR}/${target_name}_generated.h
            COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_BINARY_DIR}/${target_name}_generated.h ${_generated_file}
            VERBATIM 
            COMMENT "Generating buffer definition for ${config_file} -> ${generated_file}"
        )
        add_custom_target( ${target_name}  
                DEPENDS ${_generated_file} 
                #DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${target_name}_generated.h 
        ) 
        # the target should depend on zillians-buffer-generator
        #set_source_files_properties(${_generated_file} PROPERTIES GENERATED 1)
    else()
        # otherwise the macro should not be used, generate a warning here
        message(ERROR "zillians-buffer-generator is not available, all related macros are disabled")
    endif()

endmacro()

#
# this macro is used to preview the buffer definition (xml) schema
#
macro(zillians_show_buffer_schema target_name config_file)

    # make sure the config_file points to an absolute path
    if(IS_ABSOLUTE "${config_file}")
        set(_config_file "${config_file}")
    else()
        set(_config_file "${CMAKE_CURRENT_SOURCE_DIR}/${config_file}")
    endif()

    get_filename_component(_dot_file_name ${_config_file} NAME_WE)

    if(TARGET zillians-buffer-generator)
        set(_dot_file "${CMAKE_CURRENT_BINARY_DIR}/${_dot_file_name}.dot")
        # if the zillians-buffer-generator is built
        # create the custom target to generate buffer definition by using zillians-buffer-generator
        get_target_property(__location_zillians-buffer-generator zillians-buffer-generator LOCATION)
        add_custom_target(${target_name}
            # tricky: generate a colored message by using triple back-slash as escape character
            COMMAND ${__location_zillians-buffer-generator} -c ${_config_file} -o ${_dot_file} -d
            COMMAND ${ZILLIANS_SCRIPT_PATH}/xdot/xdot.py ${_dot_file}
            VERBATIM 
            COMMENT "Generating buffer definition schema preview for ${config_file}"
        )
        # the target should depend on zillians-buffer-generator
        add_dependencies(${target_name} zillians-buffer-generator ${_config_file})
    else()
        # otherwise the macro should not be used, generate a warning here
        message(ERROR "zillians-buffer-generator is not available, all related macros are disabled")
    endif()

endmacro()
