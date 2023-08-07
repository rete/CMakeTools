function( cmaketools_try_compile_test )
    cmake_parse_arguments( ARG "" "NAME;FILE;CXX_STANDARD;EXPECTED_RESULT" "COMPILE_DEFINITIONS;LINK_LIBRARIES" ${ARGN} )
    if( ARG_LINK_LIBRARIES )
        set( LINK_LIBS_ARG LINK_LIBRARIES ${ARG_LINK_LIBRARIES} )
    endif()
    if( ARG_COMPILE_DEFINITIONS )
        set( COMPILE_DEFS_ARG COMPILE_DEFINITIONS ${ARG_COMPILE_DEFINITIONS} )
    endif()
    if( NOT ARG_CXX_STANDARD )
        set( ARG_CXX_STANDARD ${CMAKE_CXX_STANDARD} )
    endif()
    if( "${ARG_EXPECTED_RESULT}" STREQUAL "" )
        set( ARG_EXPECTED_RESULT "TRUE" )
    endif()
    try_compile(
        ${ARG_NAME}_COMPILES
        ${CMAKE_BINARY_DIR}/try_compile
        ${ARG_FILE}
        ${LINK_LIBS_ARG}
        ${COMPILE_DEFS_ARG}
        CXX_STANDARD ${ARG_CXX_STANDARD}
        )
    add_test( NAME t_${ARG_NAME}_compile_fail COMMAND echo ${${ARG_NAME}_COMPILES} )
    set_tests_properties( t_${ARG_NAME}_compile_fail PROPERTIES PASS_REGULAR_EXPRESSION "${ARG_EXPECTED_RESULT}" )
endfunction()