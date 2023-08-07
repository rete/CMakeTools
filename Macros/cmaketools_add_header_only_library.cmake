function( cmaketools_add_header_only_library )
    cmake_parse_arguments(
        ARG
        "NO_ALIAS;NO_DOXYGEN"
        "NAME"
        "INCLUDE_DIRECTORIES;DEFINITIONS"
        ${ARGN}
        )
    # create the interface library target
    add_library( ${ARG_NAME} INTERFACE )
    if( NOT ARG_NO_ALIAS )
        add_library( ${PROJECT_NAME}::${ARG_NAME} ALIAS ${ARG_NAME} )
    endif()
    if( NOT ARG_NO_DOXYGEN )
        cmaketools_add_doxygen_input( ${ARG_INCLUDE_DIRECTORIES} )
    endif()
    if( ARG_DEFINITIONS )
        target_compile_definitions(
            ${ARG_NAME}
            PUBLIC ${ARG_DEFINITIONS}
            )
    endif()
    foreach( INCLUDE_DIR ${ARG_INCLUDE_DIRECTORIES} )
        get_filename_component( full_path ${INCLUDE_DIR} ABSOLUTE )
        target_include_directories(
            ${ARG_NAME}
            BEFORE INTERFACE
            $<BUILD_INTERFACE:${full_path}>
            )
        target_include_directories(
            ${ARG_NAME}
            INTERFACE
            $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/Libraries/${ARG_NAME}/${INCLUDE_DIR}>
            )
    endforeach()
endfunction()