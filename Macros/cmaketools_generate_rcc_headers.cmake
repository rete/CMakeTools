function( cmaketools_generate_rcc_headers )
    cmake_parse_arguments( ARG "" "RCC_OUT" "RCC_DIRECTORIES" ${ARGN} )
    # Get all ui files
    foreach( RCC_DIR ${ARG_RCC_DIRECTORIES} )
        file( GLOB ALL_RCC_FILES ${RCC_DIR}/*.qrc )
    endforeach()
    # Process all resource files
    qt5_add_resources( RCC_OUT ${ALL_RCC_FILES} )
    set( ${ARG_RCC_OUT} ${RCC_OUT} PARENT_SCOPE )
endfunction()