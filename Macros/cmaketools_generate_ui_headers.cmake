function( cmaketools_generate_ui_headers )
    cmake_parse_arguments( ARG "" "UI_INCLUDE_DIRS;UI_HEADERS" "UI_DIRECTORIES" ${ARGN} )
    # Get all ui files
    foreach( UI_DIR ${ARG_UI_DIRECTORIES} )
        file( GLOB ALL_UI_FILES ${UI_DIR}/*.ui )
    endforeach()
    # Wrap all ui files
    qt5_wrap_ui( UI_HEADERS ${ALL_UI_FILES} )
    # Get include directories for ui headers
    foreach( UI_FILE ${UI_HEADERS} )
        get_filename_component( UI_HEADER_DIR ${UI_FILE} DIRECTORY )
        list( APPEND UI_HEADER_DIRS ${UI_HEADER_DIR} )
    endforeach()
    list( REMOVE_DUPLICATES UI_HEADER_DIRS )
    set( ${ARG_UI_HEADERS} ${UI_HEADERS} PARENT_SCOPE )
    set( ${ARG_UI_INCLUDE_DIRS} ${UI_HEADER_DIRS} PARENT_SCOPE )
endfunction()