function( cmaketools_add_executable )
    cmake_parse_arguments(
        ARG
        ""
        "NAME;OUTPUT_NAME"
        "LINK_LIBRARIES;INCLUDE_DIRECTORIES;SOURCE_DIRECTORIES;SOURCE_FILES;UI_DIRECTORIES;DEFINITIONS;COMPILE_FLAGS;RCC_DIRECTORIES;MOC_SOURCES"
        ${ARGN}
        )
    # create the source list
    set( EXECUTABLE_SOURCES ${ARG_SOURCE_FILES} )
    if( ARG_SOURCE_DIRECTORIES )
        foreach( dir ${ARG_SOURCE_DIRECTORIES} )
            aux_source_directory( ${dir} EXECUTABLE_SOURCES )
        endforeach()
    endif()
    # deal with Qt stuff
    if( ARG_MOC_SOURCES OR ARG_UI_DIRECTORIES OR ARG_RCC_DIRECTORIES )
        if( NOT TARGET Qt5::Core )
            message( FATAL_ERROR "Qt package not loaded. Please use find_package( Qt REQUIRED ... ) first!" )
        endif()
    endif()
#    set( MOC_INPUTS ${ARG_INCLUDE_DIRECTORIES} ${ARG_SOURCE_DIRECTORIES} )
    if( ARG_MOC_SOURCES )
        cmaketools_generate_moc_files(
            INPUTS ${ARG_MOC_SOURCES}
            MOC_SOURCES MOC_SOURCE_FILES
            )
        list( APPEND EXECUTABLE_SOURCES ${MOC_SOURCE_FILES} )
        list( APPEND ARG_INCLUDE_DIRECTORIES ${CMAKE_CURRENT_BINARY_DIR}/Generated/Qt/moc )
    endif()
    if( NOT EXECUTABLE_SOURCES )
        message( FATAL_ERROR "No source file or directory provided for executable ${ARG_NAME}" )
    endif()
    if( ARG_UI_DIRECTORIES )
        cmaketools_generate_ui_headers(
            UI_DIRECTORIES ${ARG_UI_DIRECTORIES}
            UI_INCLUDE_DIRS UI_DIRS
            UI_HEADERS UI_H
            )
        # Add ui include directories to global list
        list( APPEND ARG_INCLUDE_DIRECTORIES ${UI_DIRS} )
        # Add ui headers to list of source
        list( APPEND EXECUTABLE_SOURCES ${UI_H} )
    endif()
    if( ARG_RCC_DIRECTORIES )
        cmaketools_generate_rcc_headers(
            RCC_DIRECTORIES ${ARG_RCC_DIRECTORIES}
            RCC_OUT RCC_OUTPUT
            )
        # Add ui headers to list of source
        list( APPEND EXECUTABLE_SOURCES ${RCC_OUTPUT} )
    endif()
    # create the executable target
    add_executable( ${ARG_NAME} ${EXECUTABLE_SOURCES} )
    list( APPEND COMPILE_DEFINITIONS ${CMAKETOOLS_COMPILE_DEFINITIONS} ${ARG_DEFINITIONS} )
    target_compile_definitions(
        ${ARG_NAME}
        PUBLIC ${COMPILE_DEFINITIONS}
        )
    set( EXECUTABLE_OUTPUT_NAME ${ARG_NAME} )
    if( ARG_OUTPUT_NAME )
        set( EXECUTABLE_OUTPUT_NAME ${ARG_OUTPUT_NAME} )
    endif()
    set_target_properties(
        ${ARG_NAME}
        PROPERTIES
        COMPILE_FLAGS "${CMAKETOOLS_CXX_FLAGS} ${ARG_COMPILE_FLAGS}"
        OUTPUT_NAME ${EXECUTABLE_OUTPUT_NAME}
        # VERSION ${PROJECT_VERSION}
        )
    if( ARG_LINK_LIBRARIES )
        target_link_libraries(
            ${ARG_NAME}
            ${ARG_LINK_LIBRARIES}
            )
    endif()
    if( ARG_INCLUDE_DIRECTORIES )
        foreach( INCLUDE_DIR ${ARG_INCLUDE_DIRECTORIES} )
            get_filename_component( full_path ${INCLUDE_DIR} ABSOLUTE )
            target_include_directories(
                ${ARG_NAME}
                BEFORE PUBLIC
                $<BUILD_INTERFACE:${full_path}>
                )
        endforeach()
    endif()
endfunction()