function( cmaketools_set_cxx_standard )
    # Set the C++ standard: 17 by default
    if( NOT CMAKE_CXX_STANDARD )
        set( CMAKE_CXX_STANDARD 17 )
    endif()
    set( CMAKE_CXX_STANDARD ${CMAKE_CXX_STANDARD} CACHE STRING "The C++ standard" )
endfunction()