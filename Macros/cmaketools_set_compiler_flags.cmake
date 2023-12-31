function( cmaketools_set_compiler_flags )
    # -fPIC flag
    set( CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL "Position independent code" )
    # The default list of CXX flags
    list( APPEND ${PROJECT_NAME}_TRY_CXX_FLAGS -Wall )
    if( ${PROJECT_NAME}_FORCE_32BITS )
        list( APPEND ${PROJECT_NAME}_TRY_CXX_FLAGS -m32 )
    endif()
    if( ${PROJECT_NAME}_USE_GPROF )
        list( APPEND ${PROJECT_NAME}_TRY_CXX_FLAGS -pg )
    endif()
    if( ${PROJECT_NAME}_WERROR )
        list( APPEND ${PROJECT_NAME}_TRY_CXX_FLAGS -Werror )
    endif()
    if( ${PROJECT_NAME}_WEXTRA )
        list( APPEND ${PROJECT_NAME}_TRY_CXX_FLAGS -Wextra )
    endif()
    # Check if flags are available for this compiler
    include( CheckCXXCompilerFlag )
    foreach( FLAG ${${PROJECT_NAME}_TRY_CXX_FLAGS} )
        string( REPLACE "-" "_" FLAG_WORD ${FLAG} )
        string( REPLACE "+" "P" FLAG_WORD ${FLAG_WORD} )
        check_cxx_compiler_flag( "${FLAG}" CXX_FLAG_WORKS_${FLAG_WORD} )
        if( ${CXX_FLAG_WORKS_${FLAG_WORD}} )
            set( CMAKETOOLS_CXX_FLAGS "${CMAKETOOLS_CXX_FLAGS} ${FLAG}" )
        endif()
    endforeach()
    # Global definitions
    set( CMAKETOOLS_COMPILE_DEFINITIONS -D_LARGEFILE64_SOURCE -D__USE_LARGEFILE64 -D_FILE_OFFSET_BITS=64 -DQT_NO_DEBUG )
    if( WIN32 )
        list( APPEND CMAKETOOLS_COMPILE_DEFINITIONS -DWindows )
    elseif(LINUX)
        list( APPEND CMAKETOOLS_COMPILE_DEFINITIONS -DLinux )
    endif()
    if( CMAKETOOLS_ARCHITECTURE EQUAL 64 AND NOT CMAKETOOLS_FORCE_32BITS )
        list( APPEND CMAKETOOLS_COMPILE_DEFINITIONS -DOS64BITS )
    endif()
    # write variables to cache
    set( CMAKETOOLS_COMPILE_DEFINITIONS      "${CMAKETOOLS_COMPILE_DEFINITIONS}" CACHE STRING "The project global compile definitions" )
    set( CMAKETOOLS_CXX_FLAGS                "${CMAKETOOLS_CXX_FLAGS}"           CACHE STRING "The project global cxx flags" )
endfunction()