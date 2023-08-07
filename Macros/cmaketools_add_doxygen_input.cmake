################################################################################
#  Add a source (file or directory) to the list of doxygen sources
#
################################################################################
function( cmaketools_add_doxygen_input _input )
    if( ${PROJECT_NAME}_GENERATE_DOXYGEN )
        get_filename_component( full_path ${_input} ABSOLUTE )
        get_property( DOXYGEN_SOURCES GLOBAL PROPERTY PROJECT_DOXYGEN_SOURCES )
        list( APPEND DOXYGEN_SOURCES ${full_path} )
        list( REMOVE_DUPLICATES DOXYGEN_SOURCES )
        set_property( GLOBAL PROPERTY PROJECT_DOXYGEN_SOURCES ${DOXYGEN_SOURCES} )
    endif()
endfunction()