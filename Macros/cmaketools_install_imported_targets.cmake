function( cmaketools_install_imported_targets )
    cmake_parse_arguments( ARG "" "DESTINATION" "TARGETS" ${ARGN} )
    foreach( target ${ARG_TARGETS} )
        get_property( TARGET_IMPORTED_CONFIG TARGET ${target} PROPERTY IMPORTED_CONFIGURATIONS )
        if( NOT TARGET_IMPORTED_CONFIG )
            install(
                FILES
                $<TARGET_PROPERTY:${target},INTERFACE_IMPORTED_LOCATION>
                DESTINATION
                ${ARG_DESTINATION}
                )
#            message( FATAL_ERROR "Imported target '${target}' has no IMPORTED_CONFIGURATIONS property" )
        else()
            install(
                FILES
                $<TARGET_PROPERTY:${target},IMPORTED_LOCATION_${TARGET_IMPORTED_CONFIG}>
                DESTINATION
                ${ARG_DESTINATION}
                )
        endif()
    endforeach()
endfunction()