################################################################################
#  Create a rule to generate Doxygen documentation out of source files
#
# Does the following:
#  - Find the Doxygen package
#  - Get the list of sources from the global property PROJECT_DOXYGEN_SOURCES
#  - Generate a Doxyfile using 'cmaketools_configure_doxyfile()'
#  - Add a custom target named 'doxygen'
#
################################################################################
function( cmaketools_generate_package_doxygen)
    cmake_parse_arguments( ARG "" "DOXYFILE;OUTPUT_DIRECTORY" "" ${ARGN} )
    if( NOT TARGET Doxygen::doxygen )
        find_package( Doxygen REQUIRED )
    endif()
    get_property( DOXYGEN_SOURCES GLOBAL PROPERTY PROJECT_DOXYGEN_SOURCES )
    if( NOT ARG_OUTPUT_DIRECTORY )
        set( ARG_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/Doxygen )
    endif()
    file( MAKE_DIRECTORY ${ARG_OUTPUT_DIRECTORY} )
    if(NOT ARG_DOXYFILE)
        set( ARG_DOXYFILE ${CMAKE_BINARY_DIR}/Doxyfile )
    endif()
    if(NOT EXISTS ${ARG_DOXYFILE})
        message( FATAL_ERROR "Input Doxyfile not found: ${ARG_DOXYFILE}" )
    endif()
    add_custom_target(
        doxygen
        COMMENT "Generating doxygen API..."
        COMMAND Doxygen::doxygen ${ARG_DOXYFILE}
        DEPENDS ${ARG_DOXYFILE}
        )
    install(
        DIRECTORY ${ARG_OUTPUT_DIRECTORY}
        DESTINATION Documentation
        )
endfunction()