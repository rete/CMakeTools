function( cmaketools_export_env_variable )
    cmake_parse_arguments( ARG "APPEND" "VARIABLE;VALUE" "" ${ARGN} )
    if( NOT ARG_VARIABLE )
        return()
    endif()
    if( ARG_APPEND )
        set( APPEND_KEYWORD APPEND )
    endif()
    # Append variable to global list
    get_property( PROJECT_ENV_VARS GLOBAL PROPERTY PROJECT_ENV_VARS )
    list( APPEND PROJECT_ENV_VARS ${ARG_VARIABLE} )
    list( REMOVE_DUPLICATES PROJECT_ENV_VARS )
    set_property( GLOBAL PROPERTY PROJECT_ENV_VARS ${PROJECT_ENV_VARS} )
    # Set the variable itself
    set_property( GLOBAL ${APPEND_KEYWORD} PROPERTY ENV_EXPORT_${ARG_VARIABLE} ${ARG_VALUE} )
endfunction()