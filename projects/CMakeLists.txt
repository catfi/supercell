# temporary work-around to define cross-project directories

SET(PROJECT_CLIENT_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/client)
SET(PROJECT_COMMON_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/common)
SET(PROJECT_PROTOCOL_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/protocol)
SET(PROJECT_MQ_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/mq)
SET(PROJECT_CLIENT_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/client)
SET(PROJECT_FRAMEWORK_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/framework)
SET(PROJECT_NODE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/node)
SET(PROJECT_VGPU_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/vgpu)

# include all subdirectories containing CMakeLists.txt

file(GLOB all_valid_subdirs RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "*/CMakeLists.txt")

foreach(dir ${all_valid_subdirs})
    if(${dir} MATCHES "^([^/]*)//CMakeLists.txt")
        string(REGEX REPLACE "^([^/]*)//CMakeLists.txt" "\\1" dir_trimmed ${dir})
		message(STATUS "Adding Sub-Project Directory: ${dir_trimmed}")
        add_subdirectory(${dir_trimmed})
    endif()
endforeach(dir)
