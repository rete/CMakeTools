################################################################################
# Get the Linux platform, kernel version and architecture
#
# Example usage:
#     CMAKETOOLS_get_architecture( CMAKETOOLS_PLATFORM CMAKETOOLS_KERNEL CMAKETOOLS_ARCHITECTURE )
#
# Output:
#     - CMAKETOOLS_PLATFORM: The OS platform; Ubuntu-22.04_64
#     - CMAKETOOLS_KERNEL: The kernel version
#     - CMAKETOOLS_ARCHITECTURE: 32 or 64.
################################################################################
function( cmaketools_get_architecture _PLATFORM _KERNEL _ARCHITECTURE )

    # 32 or 64 bits ?
    set( CMAKETOOLS_ARCHITECTURE_BITS 32 )
    if( CMAKE_SIZEOF_VOID_P EQUAL 8 )
        set( CMAKETOOLS_ARCHITECTURE_BITS 64 )
    endif()
    set( CMAKETOOLS_PLATFORM_NAME "Other_${CMAKETOOLS_ARCHITECTURE_BITS}" )
    # default value for kernel version
    set( CMAKETOOLS_KERNEL_VERSION ${CMAKE_SYSTEM_VERSION} )
    if(WIN32)
        set( CMAKETOOLS_PLATFORM_NAME "Windows_${CMAKETOOLS_ARCHITECTURE_BITS}" )
    elseif(APPLE)
        set( CMAKETOOLS_PLATFORM_NAME "Apple_${CMAKETOOLS_ARCHITECTURE_BITS}" )
    else()
        find_program(UNAME_EXECUTABLE uname)
        find_program(LSB_RELEASE_EXECUTABLE lsb_release)
        if(LSB_RELEASE_EXECUTABLE AND UNAME_EXECUTABLE)
            # Get the Linux Kernel version
            execute_process( COMMAND ${UNAME_EXECUTABLE} -r OUTPUT_VARIABLE UNAME_RES OUTPUT_STRIP_TRAILING_WHITESPACE )
            string( REPLACE "-" ";" UNAME_RES ${UNAME_RES} )
            list( GET UNAME_RES 0 CMAKETOOLS_KERNEL_VERSION )
            execute_process( COMMAND ${LSB_RELEASE_EXECUTABLE} -si OUTPUT_VARIABLE LSB_FLAVOR OUTPUT_STRIP_TRAILING_WHITESPACE )
            execute_process( COMMAND ${LSB_RELEASE_EXECUTABLE} -sr OUTPUT_VARIABLE LSB_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE )
            set( CMAKETOOLS_PLATFORM_NAME "${LSB_FLAVOR}-${LSB_VERSION}_${CMAKETOOLS_ARCHITECTURE_BITS}" )
        endif()
    endif()
    # Write variable to cache
    set( ${_PLATFORM}        "${CMAKETOOLS_PLATFORM_NAME}" PARENT_SCOPE )
    set( ${_KERNEL}          "${CMAKETOOLS_KERNEL_VERSION}" PARENT_SCOPE )
    set( ${_ARCHITECTURE}    "${CMAKETOOLS_ARCHITECTURE_BITS}" PARENT_SCOPE )
endfunction()