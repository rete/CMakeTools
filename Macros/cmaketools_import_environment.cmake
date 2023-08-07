################################################################################
# Import environment variables into CMake global property namespace
#
# Signature:
#   cmaketools_import_environment(
#       [NAMESPACE <namespace>]
#       [PRE_COMMAND <command>]
#   )
#
# The NAMESPACE option specifies the prefix for the global properties, by
# default 'ENV'. For example, for the environment variable FOO, the global
# property ENV_FOO will be created.
# The PRE_COMMAND option allows you to add a
# shell command before populating the environment. This can be useful if you
# want for example to source a script that adds more variable before populating
# the CMake properties.
# Note that a global property <NAMESPACE>_ALL_VARS lists all imported variables.
#
################################################################################
function( cmaketools_import_environment )
    set( IMPORT_ENV_SCRIPT ${CMAKETOOLS_TEMPLATES_DIR}/ImportEnvironment.sh.in )
    cmake_parse_arguments( ARG "" "PRE_COMMAND;NAMESPACE" "" ${ARGN} )
    set( CMAKETOOLS_ENVIRONMENT_NAMESPACE ENV )
    if( ARG_NAMESPACE )
        set( CMAKETOOLS_ENVIRONMENT_NAMESPACE ${ARG_NAMESPACE} )
    endif()
    if( ARG_PRE_COMMAND )
        set( CMAKETOOLS_ENV_PRECOMMAND "${ARG_PRE_COMMAND}" )
    endif()
    set( CMAKETOOLS_ENVIRONMENT_FILE ${CMAKE_BINARY_DIR}/CMakeImportEnvFile.cmake )
    set( CMAKETOOLS_IMPORT_ENV_FILE_TMP ${CMAKE_BINARY_DIR}/tmp/ImportEnvVars.sh )
    set( CMAKETOOLS_IMPORT_ENV_FILE ${CMAKE_BINARY_DIR}/ImportEnvVars.sh )
    # cleanup files and global properties from previous calls
    if( EXISTS ${CMAKETOOLS_IMPORT_ENV_FILE} )
        file( REMOVE ${CMAKETOOLS_IMPORT_ENV_FILE} )
    endif()
    get_property( EVARS GLOBAL PROPERTY ${CMAKETOOLS_ENVIRONMENT_NAMESPACE}_ALL_VARS )
    foreach( evar ${EVARS} )
        set_property( GLOBAL PROPERTY ${CMAKETOOLS_ENVIRONMENT_NAMESPACE}_${evar} )
    endforeach()
    # ready to import the env
    configure_file(
        ${IMPORT_ENV_SCRIPT}
        ${CMAKETOOLS_IMPORT_ENV_FILE_TMP}
        @ONLY
        )
    file(
        COPY ${CMAKETOOLS_IMPORT_ENV_FILE_TMP}
        DESTINATION ${CMAKE_BINARY_DIR}
        FILE_PERMISSIONS
        OWNER_READ OWNER_WRITE OWNER_EXECUTE
        GROUP_READ GROUP_EXECUTE
        WORLD_READ WORLD_EXECUTE
        )
    execute_process(
        COMMAND ${CMAKETOOLS_IMPORT_ENV_FILE}
        )
    include( ${CMAKETOOLS_ENVIRONMENT_FILE} )
    if( ${PROJECT_NAME}_CMAKE_DEBUG )
        cmaketools_print_env( ${CMAKETOOLS_ENVIRONMENT_NAMESPACE} )
    endif()
endfunction()