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

function( ADD_CUSTOM_POST_COPY TGT SRC DST )
        FILE( MAKE_DIRECTORY ${DST} )

        file(GLOB tmpFiles RELATIVE ${SRC} ${SRC}/*)

        foreach( tmpFile ${tmpFiles} )
                SET(COPY_FROM	${SRC}/${tmpFile} )
		SET(COPY_TO	${DST}/${tmpFile} )
                IF( IS_DIRECTORY ${COPY_FROM} )
                        ADD_CUSTOM_POST_COPY( ${TGT} ${COPY_FROM} ${COPY_TO} )
                ELSE()
                        add_custom_command( TARGET ${TGT}
                                POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy  ${COPY_FROM} ${COPY_TO}
                        )
                ENDIF()
        endforeach() 
endfunction( ADD_CUSTOM_POST_COPY)


macro( zillians_add_post_copy )
    set(__option_catalogries "TARGET;FROM;DEPENDS;TO")
    set(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set) 
    
    # check if the number of targets specified is wrong
    hashmap(GET __options_set "TARGET" __target)
    hashmap(GET __options_set "FROM" __sources)
    hashmap(GET __options_set "DEPENDS" __depends)
    hashmap(GET __options_set "TO" __to)

    foreach( S ${__sources} )
        IF( IS_DIRECTORY ${S} )
            file(GLOB toBeCopied RELATIVE ${S} ${S}/*)
            get_filename_component( PARENT ${S} PATH)
            string(REPLACE "${PARENT}" "" FOLDER_NAME ${S} )

            foreach( one ${toBeCopied} )
                IF( IS_DIRECTORY ${S}/${one} )
                    zillians_add_post_copy( 
                            TARGET ${__target}
                            FROM    ${S}/${one}
                            TO      ${__to}/${FOLDER_NAME}/
                            DEPENDS ${__depends}
                    )
                ELSE()
                    add_custom_command( TARGET ${__target}
                        POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy  ${S}/${one} ${__to}/${FOLDER_NAME}/${one}
                        DEPENDS ${__depends}
                    ) 
                ENDIF()
            endforeach() 
        ELSE()
            add_custom_command( TARGET ${__target}
                POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy  ${S} ${__to}/
                DEPENDS ${__depends}
            ) 
        ENDIF()
    endforeach() 
endmacro()

macro( zillians_add_copy_during_configure)
    set(__option_catalogries "FROM;TO")
    set(__temporary_options_variable ${ARGN})
    split_options(__temporary_options_variable "default" __option_catalogries __options_set) 
    
    # check if the number of targets specified is wrong
    hashmap(GET __options_set "FROM" __sources)
    hashmap(GET __options_set "TO" __to)

    foreach( S ${__sources} )
        IF( IS_DIRECTORY ${S} )
            file(GLOB toBeCopied RELATIVE ${S} ${S}/*)

            get_filename_component( PARENT ${S} PATH)
            string(REPLACE "${PARENT}" "" FOLDER_NAME ${S} )

            foreach( one ${toBeCopied} )
                EXECUTE_PROCESS( COMMAND ${CMAKE_COMMAND} -E copy_if_different ${S}/${one} ${__to}/${FOLDER_NAME}/${one} )
            endforeach()
        ELSE()
            get_filename_component( FN ${S} NAME )
            EXECUTE_PROCESS( COMMAND ${CMAKE_COMMAND} -E copy_if_different ${S} ${__to}/${FN} )
        ENDIF()
    endforeach()
endmacro()

