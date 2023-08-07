function( cmaketools_install_library )
    cmake_parse_arguments( ARG "EXPORT;PLUGIN" "PACKAGE;LIBRARY" "" ${ARGN} )
    if( ARG_EXPORT )
        set( EXPORT_KEYWORD EXPORT )
        set( EXPORT_NAMESPACE ${PROJECT_NAME} )
    endif()
    get_target_property( target_type ${ARG_LIBRARY} TYPE )
    # interface library case
    if( "${target_type}" STREQUAL "INTERFACE_LIBRARY" )
        install(
            TARGETS ${ARG_LIBRARY}
            ${EXPORT_KEYWORD} ${EXPORT_NAMESPACE}
            PUBLIC_HEADER DESTINATION Libraries/${ARG_PACKAGE}/include
            )
        return()
    endif()
    # static and shared library case
    if( "${target_type}" STREQUAL "STATIC_LIBRARY" )
        set( LIBRARY_TYPE ARCHIVE )
    elseif( "${target_type}" STREQUAL "SHARED_LIBRARY" )
        set( LIBRARY_TYPE LIBRARY )
    else()
        message( FATAL_ERROR "Wrong target type. Expecting static or shared library" )
    endif()
    install(
        TARGETS ${ARG_LIBRARY}
        ${EXPORT_KEYWORD} ${EXPORT_NAMESPACE}
        PUBLIC_HEADER DESTINATION Libraries/${ARG_PACKAGE}/include
        ${LIBRARY_TYPE} DESTINATION Libraries/${ARG_PACKAGE}/lib/${CMAKETOOLS_PLATFORM}
        )
    if( ARG_PLUGIN )
        if( NOT "${target_type}" STREQUAL "SHARED_LIBRARY" )
            message( STATUS "Plugin library must be a shared library!" )
        endif()
        set( fulllib ${CMAKE_INSTALL_PREFIX}/Libraries/${ARG_PACKAGE}/lib/${CMAKETOOLS_PLATFORM}/$<TARGET_FILE_NAME:${ARG_LIBRARY}> )
        cmaketools_export_env_variable( APPEND VARIABLE PLUGINS VALUE ${fulllib} )
    endif()
endfunction()