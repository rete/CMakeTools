################################################################################
# Configure and generate a Doxyfile
#
# Signature:
#   cmaketools_configure_doxyfile(
#       [GENERATE_HTML] [GENERATE_LATEX] [GENERATE_RTF] [GENERATE_MAN] [GENERATE_XML] [GENERATE_DEFAULT]
#       [PROJECT_NAME <string>]
#       [PROJECT_VERSION <version>]
#       [OUTPUT_DIRECTORY <dir>]
#       [OUTPUT_LANGUAGE <language>]
#       [DOXYGEN_TEMPLATE <file>]
#       [OUTPUT_DOXYFILE <file>]
#       [INPUT_SOURCES <src> ...]
#   )
#
# By default, no documentation will be generated. To generate HTML, LaTeX, RTF,
# man pages or XML use the options accordingle. The option GENERATE_DEFAULT sets
# HTML and LATEX documentation to ON. The PROJECT_NAME and PROJECT_VERSION
# options set the project name and version respectively in the Doxyfile, by
# default the project name and version declared in the top-level CMakeLists.txt.
# The OUTPUT_DIRECTORY option specifies where the documentation will be generated
# when running Doxygen with the generated Doxyfile, by default "doc" in the
# install prefix directory. The OUTPUT_LANGUAGE sets the language of the resulting
# documentation, by default "French". The DOXYGEN_TEMPLATE is the template doxyfile
# for generating the final version of the Doxyfile using a `configure_file()`
# command. The OUTPUT_DOXYFILE sets the name of the Doxyfile (absolute path), by
# default in the current CMake binary directory, with the name "Doxyfile". The
# only mandatory argument is INPUT_SOURCES which provides the list of sources for
# doxygen to parse the documentation. It can be directories or list source files.
#
################################################################################
function( cmaketools_configure_doxyfile )
    cmake_parse_arguments(
        ARG
        "GENERATE_DEFAULT;GENERATE_HTML;GENERATE_LATEX;GENERATE_RTF;GENERATE_MAN;GENERATE_XML"
        "PROJECT_NAME;PROJECT_VERSION;OUTPUT_DIRECTORY;OUTPUT_LANGUAGE;DOXYGEN_TEMPLATE;OUTPUT_DOXYFILE"
        "INPUT_SOURCES"
        ${ARGN}
        )
    if( NOT ARG_INPUT_SOURCES )
        get_property( ARG_INPUT_SOURCES GLOBAL PROPERTY PROJECT_DOXYGEN_SOURCES )
    endif()
    string( REPLACE ";" " " DOXY_INPUT_SOURCES "${ARG_INPUT_SOURCES}" )
    set( DOXY_PROJECT_NAME "${PROJECT_NAME}" )
    if( ARG_PROJECT_NAME )
        set( DOXY_PROJECT_NAME ${ARG_PROJECT_NAME} )
    endif()
    set( DOXY_PROJECT_VERSION "${${PROJECT_NAME}_VERSION_SHORT}" )
    if( ARG_PROJECT_VERSION )
        set( DOXY_PROJECT_VERSION ${ARG_PROJECT_VERSION} )
    endif()
    set( DOXY_OUTPUT_DIRECTORY Documentation )
    if( ARG_OUTPUT_DIRECTORY )
        set( DOXY_OUTPUT_DIRECTORY ${ARG_OUTPUT_DIRECTORY} )
    endif()
    set( DOXY_OUTPUT_LANGUAGE French )
    if( ARG_OUTPUT_LANGUAGE )
        set( DOXY_OUTPUT_LANGUAGE ${ARG_OUTPUT_LANGUAGE} )
    endif()
    if( ARG_DOXYGEN_TEMPLATE )
        set( DOXYGEN_TEMPLATE ${ARG_DOXYGEN_TEMPLATE} )
    elseif( EXISTS ${CMAKETOOLS_TEMPLATES_DIR}/Doxyfile.in )
        set( DOXYGEN_TEMPLATE ${CMAKETOOLS_TEMPLATES_DIR}/Doxyfile.in )
    else()
        message( FATAL_ERROR "No template Doxyfile input provided!" )
    endif()
    set( OUTPUT_DOXYFILE ${CMAKE_BINARY_DIR}/Doxyfile )
    if( ARG_OUTPUT_DOXYFILE )
        set( OUTPUT_DOXYFILE ${ARG_OUTPUT_DOXYFILE} )
    endif()
    if( ARG_GENERATE_DEFAULT )
        set( DOXY_GENERATE_HTML YES )
        set( DOXY_GENERATE_LATEX YES )
        set( DOXY_GENERATE_RTF NO )
        set( DOXY_GENERATE_MAN NO )
        set( DOXY_GENERATE_XML NO )
    else()
        set( DOXY_GENERATE_HTML NO )
        set( DOXY_GENERATE_LATEX NO)
        set( DOXY_GENERATE_RTF NO )
        set( DOXY_GENERATE_MAN NO )
        set( DOXY_GENERATE_XML NO )
        if( ARG_GENERATE_HTML )
            set( DOXY_GENERATE_HTML YES )
        endif()
        if( ARG_GENERATE_LATEX )
            set( DOXY_GENERATE_LATEX YES )
        endif()
        if( ARG_GENERATE_RTF )
            set( DOXY_GENERATE_RTF YES )
        endif()
        if( ARG_GENERATE_MAN )
            set( DOXY_GENERATE_MAN YES )
        endif()
        if( ARG_GENERATE_XML )
            set( DOXY_GENERATE_XML YES )
        endif()
    endif()
    message( STATUS "Generating Doxyfile: ${OUTPUT_DOXYFILE} ..." )
    configure_file(
        ${DOXYGEN_TEMPLATE}
        ${OUTPUT_DOXYFILE}
        @ONLY
        )
endfunction()