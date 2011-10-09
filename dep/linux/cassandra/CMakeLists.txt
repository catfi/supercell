PROJECT(cassandra_thrift_api)

#ADD_DEFINITIONS(-DUNIX)

INCLUDE_DIRECTORIES(
    ${CMAKE_CURRENT_SOURCE_DIR}/include 
    ${THRIFT_INCLUDE_DIR}
    )
    
ADD_LIBRARY(cassandra_thrift_api
    src/cassandra_constants.cpp
    src/cassandra_types.cpp
    src/Cassandra.cpp
    )

#TARGET_LINK_LIBRARIES(cudpp_custom_build cudpp_custom_build_nvcc cutil_custom_build)
TARGET_LINK_LIBRARIES(cassandra_thrift_api
    ${THRIFT_LIBRARIES} 
    ) 
