function( cmaketools_add_library )
    cmake_parse_arguments(
        ARG
        "STATIC;SHARED;NO_ALIAS;NO_DOXYGEN"
        "NAME;OUTPUT_NAME"
        "LINK_LIBRARIES;INCLUDE_DIRECTORIES;SOURCE_DIRECTORIES;SOURCE_FILES;UI_DIRECTORIES;DEFINITIONS;COMPILE_FLAGS;RCC_DIRECTORIES;MOC_SOURCES"
        ${ARGN}
        )
    # static or shared?
    if( (ARG_SHARED AND ARG_STATIC) OR (NOT ARG_STATIC AND NOT ARG_SHARED) )
        message( FATAL_ERROR "Library ${ARG_NAME} has to be either be static or shared" )
    endif()
    set( LIBRARY_TYPE SHARED )
    set( INSTALL_TYPE LIBRARY )
    if( ARG_STATIC )
        set( LIBRARY_TYPE STATIC )
        set( INSTALL_TYPE ARCHIVE )
    endif()
    # create the source list
    set( LIBRARY_SOURCES ${ARG_SOURCE_FILES} )
    if( ARG_SOURCE_DIRECTORIES )
        foreach( dir ${ARG_SOURCE_DIRECTORIES} )
            aux_source_directory( ${dir} LIBRARY_SOURCES )
        endforeach()
    endif()
    set( BUILD_INCLUDES ${ARG_INCLUDE_DIRECTORIES} )
    set( INSTALL_INCLUDES ${ARG_INCLUDE_DIRECTORIES} )
    # deal with Qt stuff
    if( ARG_MOC_SOURCES OR ARG_UI_DIRECTORIES OR ARG_RCC_DIRECTORIES )
        if( NOT TARGET Qt5::Core )
            message( FATAL_ERROR "Qt5 package not loaded. Please use find_package( Qt5 REQUIRED ... ) first!" )
        endif()
    endif()
    if( ARG_MOC_SOURCES )
        cmaketools_generate_moc_files(
            INPUTS ${ARG_MOC_SOURCES}
            MOC_SOURCES MOC_SOURCE_FILES
            MOC_DEPENDS_TARGETS MOC_TARGETS
            MOC_OUTPUT_INCDIRS MOC_INCDIRS
            )
        list( APPEND LIBRARY_SOURCES ${MOC_SOURCE_FILES} )
    endif()
    if( NOT LIBRARY_SOURCES )
        message( FATAL_ERROR "No source file or directory provided for library ${ARG_NAME}" )
    endif()
    if( ARG_UI_DIRECTORIES )
        cmaketools_generate_ui_headers(
            UI_DIRECTORIES ${ARG_UI_DIRECTORIES}
            UI_INCLUDE_DIRS UI_DIRS
            UI_HEADERS UI_H
            )
        # Add ui include directories to global list
        list( APPEND BUILD_INCLUDES ${UI_DIRS} )
        # Add ui headers to list of source
        list( APPEND LIBRARY_SOURCES ${UI_H} )
    endif()
    if( ARG_RCC_DIRECTORIES )
        cmaketools_generate_rcc_headers(
            RCC_DIRECTORIES ${ARG_RCC_DIRECTORIES}
            RCC_OUT RCC_OUTPUT
            )
        # Add ui headers to list of source
        list( APPEND LIBRARY_SOURCES ${RCC_OUTPUT} )
    endif()
    # create the library target
    add_library( ${ARG_NAME} ${LIBRARY_TYPE} ${LIBRARY_SOURCES} )
    if( NOT ARG_NO_ALIAS )
        add_library( ${PROJECT_NAME}::${ARG_NAME} ALIAS ${ARG_NAME} )
    endif()
    if(MOC_TARGETS)
        add_dependencies( ${ARG_NAME} ${MOC_TARGETS} )
    endif()
    if(MOC_INCDIRS)
        target_include_directories( ${ARG_NAME} PRIVATE ${MOC_INCDIRS} )
    endif()
    list( APPEND COMPILE_DEFINITIONS ${CMAKETOOLS_COMPILE_DEFINITIONS} ${ARG_DEFINITIONS} )
    target_compile_definitions(
        ${ARG_NAME}
        PUBLIC ${COMPILE_DEFINITIONS}
        )
    set( LIBRARY_OUTPUT_NAME ${ARG_NAME} )
    if( ARG_OUTPUT_NAME )
        set( LIBRARY_OUTPUT_NAME ${ARG_OUTPUT_NAME} )
    endif()
    set_target_properties(
        ${ARG_NAME}
        PROPERTIES
        COMPILE_FLAGS "${CMAKETOOLS_CXX_FLAGS} ${ARG_COMPILE_FLAGS}"
        OUTPUT_NAME ${LIBRARY_OUTPUT_NAME}
        # VERSION ${PROJECT_VERSION}
        )
    if( NOT ARG_NO_DOXYGEN )
        foreach(f ${LIBRARY_SOURCES})
            cmaketools_add_doxygen_input( ${f} )
        endforeach()
        if( ARG_INCLUDE_DIRECTORIES )
            cmaketools_add_doxygen_input( ${ARG_INCLUDE_DIRECTORIES} )
        endif()
    endif()
    if( ARG_LINK_LIBRARIES )
        target_link_libraries(
            ${ARG_NAME}
            PUBLIC
            ${ARG_LINK_LIBRARIES}
            )
    endif()
    if( BUILD_INCLUDES )
        foreach( INCLUDE_DIR ${BUILD_INCLUDES} )
            get_filename_component( full_path ${INCLUDE_DIR} ABSOLUTE )
            target_include_directories(
                ${ARG_NAME}
                BEFORE PUBLIC
                $<BUILD_INTERFACE:${full_path}>
                )
        endforeach()
    endif()
    if( INSTALL_INCLUDES )
        foreach( INCLUDE_DIR ${INSTALL_INCLUDES} )
            get_filename_component( full_path ${INCLUDE_DIR} ABSOLUTE )
            target_include_directories(
                ${ARG_NAME}
                INTERFACE
                $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/Libraries/${ARG_NAME}/${INCLUDE_DIR}>
                )
        endforeach()
    endif()
endfunction()