include (CMakeForceCompiler)
option(ENABLE_ICECC "Enable icecc checking, for distributed compilation")
if (ENABLE_ICECC)
    find_program(ICECC icecc)
    if (ICECC)
        message(STATUS "Icecream (icecc) found! Using distributed compilation for all")
        
        SET(CMAKE_CXX_COMPILER_WORKS 1 CACHE INTERNAL "")
        
        cmake_force_cxx_compiler(${ICECC} icecc)
        cmake_force_c_compiler(${ICECC} icecc)
        
        # force the compiler architecture to x86-64
        set(CMAKE_SIZEOF_VOID_P 8)
        
        set(CMAKE_CXX_FLAGS_DEBUG "-g" CACHE STRING "cxx flags for debug" FORCE)
        set(CMAKE_CXX_FLAGS_MINSIZEREL "-Os -DNDEBUG" CACHE STRING "cxx flags for minimal size released" FORCE)
        set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG" CACHE STRING "cxx flags for released" FORCE)
        set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g" CACHE STRING "cxx flags for released with debug info" FORCE)
        
        set(CMAKE_C_FLAGS_DEBUG "-g" CACHE STRING "c flags for debug" FORCE)
        set(CMAKE_C_FLAGS_MINSIZEREL "-Os -DNDEBUG" CACHE STRING "c flags for minimal size released" FORCE)
        set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG" CACHE STRING "c flags forreleased" FORCE)
        set(CMAKE_C_FLAGS_RELWITHDEBINFO "-O2 -g" CACHE STRING "c flags for released with debug info" FORCE)
        
    else(ICECC)
        message(FATAL_ERROR "Icecream (icecc) NOT found! re-run cmake without -D ENABLE_ICECC=true")
    endif(ICECC)
endif(ENABLE_ICECC)
