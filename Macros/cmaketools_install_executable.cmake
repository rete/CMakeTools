function( cmaketools_install_executable )
    cmake_parse_arguments( ARG "EXPORT" "PACKAGE;EXECUTABLE" "" ${ARGN} )
    get_target_property( target_type ${ARG_EXECUTABLE} TYPE )
    if( NOT "${target_type}" STREQUAL "EXECUTABLE" )
        message( FATAL_ERROR "Wrong target type. Expecting executable" )
    endif()
    if( ARG_EXPORT )
        set( EXPORT_KEYWORD EXPORT )
        set( EXPORT_NAMESPACE ${PROJECT_NAME} )
    endif()
    install(
        TARGETS ${ARG_EXECUTABLE}
        ${EXPORT_KEYWORD} ${EXPORT_NAMESPACE}
        RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/Applications/${ARG_PACKAGE}/bin/${CMAKETOOLS_PLATFORM}
        )
    cmaketools_export_env_variable( APPEND VARIABLE PATH VALUE ${CMAKE_INSTALL_PREFIX}/Applications/${ARG_PACKAGE}/bin/${CMAKETOOLS_PLATFORM} )
endfunction()