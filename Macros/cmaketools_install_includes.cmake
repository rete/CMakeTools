function( cmaketools_install_includes _incdir )
    if( PACKAGE_NAME )
        install(
            DIRECTORY ${_incdir}
            DESTINATION ${CMAKE_INSTALL_PREFIX}/Libraries/${PACKAGE_NAME}
            )
    else()
        install(
            DIRECTORY ${_incdir}
            DESTINATION ${CMAKE_INSTALL_PREFIX}
            )
    endif()
endfunction()