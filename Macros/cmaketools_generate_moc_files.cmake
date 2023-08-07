function( cmaketools_generate_moc_files )
    cmake_parse_arguments( ARG "" "MOC_SOURCES;MOC_DEPENDS_TARGETS;MOC_OUTPUT_INCDIRS" "INPUTS" ${ARGN} )
    foreach( input ${ARG_INPUTS} )
        file( GLOB_RECURSE files ${input}/*.h ${input}/*.hxx ${input}/*.hh ${input}/*.cxx ${input}/*.cc ${input}/*.cpp )
        list( APPEND MOC_CANDIDATE_LIST ${files} )
    endforeach()
    # TODO: transform this to CMake code.
    # Kept as it is for the moment to ensure backward compatibility
    foreach( moc_file ${MOC_CANDIDATE_LIST} )
        execute_process(
            COMMAND grep -H Q_OBJECT ${moc_file}
            COMMAND cut -d: -f 1
            COMMAND sort -u
            OUTPUT_VARIABLE MOC_CANDIDATE
            OUTPUT_STRIP_TRAILING_WHITESPACE
            )
        if( MOC_CANDIDATE )
            get_filename_component( MOC_FNAME ${moc_file} NAME )
            get_filename_component( MOC_FEXT ${moc_file} EXT )
            string( REPLACE "." "_" MOC_FNAME ${MOC_FNAME} )
            set( MOC_SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Generated/Qt/moc/moc_${MOC_FNAME}.cpp )
            # check whether the source file already includes the moc file
            set( SRC_EXTENSIONS .cpp .cc .cxx )
            if( "${MOC_FEXT}" IN_LIST SRC_EXTENSIONS )
                get_filename_component( MOC_FWE ${moc_file} NAME_WE )
                execute_process(
                    COMMAND grep -H moc_${MOC_FWE}.cpp ${moc_file}
                    COMMAND cut -d: -f 1
                    COMMAND sort -u
                    OUTPUT_VARIABLE MOC_CC_STANDALONE
                    OUTPUT_STRIP_TRAILING_WHITESPACE
                    )
                if( NOT MOC_CC_STANDALONE )
                    message( FATAL_ERROR "Qt MOC limitation: source files with Q_OBJECT macro must include their own moc file (${MOC_FWE})" )
                endif()
                set( WCPP )
                qt5_wrap_cpp( WCPP ${MOC_CANDIDATE} )
                get_filename_component( WCPP_DIR ${WCPP} DIRECTORY )
                list( APPEND MOC_OUTPUT_INCDIRS ${WCPP_DIR} )
                add_custom_target( mocgen_${MOC_FNAME} DEPENDS ${WCPP} )
                list( APPEND MOC_DEPENDS_TARGETS mocgen_${MOC_FNAME} )
            else()
                qt5_generate_moc( ${moc_file} ${MOC_SOURCE_FILE} )
                list( APPEND MOC_SOURCE_FILES ${MOC_SOURCE_FILE} )
            endif()
        endif()
    endforeach()
    if( MOC_SOURCE_FILES )
        # Set moc source files
        set( ${ARG_MOC_SOURCES} ${MOC_SOURCE_FILES} PARENT_SCOPE )
    endif()
    if(MOC_DEPENDS_TARGETS)
        set( ${ARG_MOC_DEPENDS_TARGETS} ${MOC_DEPENDS_TARGETS} PARENT_SCOPE )
    endif()
    if(MOC_OUTPUT_INCDIRS)
        list( REMOVE_DUPLICATES MOC_OUTPUT_INCDIRS )
        set( ${ARG_MOC_OUTPUT_INCDIRS} ${MOC_OUTPUT_INCDIRS} PARENT_SCOPE )
    endif()
endfunction()