###
# FindKDIS.cmake file
# Module to find the KDIS library
#
# Input variables:
#   KDIS_ROOT:               KDIS guess location
#   KDIS_VERSION:            The KDIS implementation version to use
#
# Sets the following variables:
#   KDIS_FOUND:              Whether KDIS was found
#   KDIS_VERSION:            The KDIS version found
#
# Sets the following targets:
#   KDIS::shared_library:    The KDIS shared library target shipped with include directories
#   KDIS::static_library:    The KDIS static library target shipped with include directories
###

cmake_policy( SET CMP0057 NEW )

set( KDIS_FOUND )

if( NOT KDIS_FIND_VERSION )
	set( KDIS_FIND_VERSION 6 )
endif()

set( KDIS_POSSIBLE_VERSIONS 5 6 7 )

if( NOT KDIS_FIND_VERSION IN_LIST KDIS_POSSIBLE_VERSIONS )
	message( FATAL_ERROR "KDIS version ${KDIS_FIND_VERSION} not allowed. Please use on these versions: ${KDIS_POSSIBLE_VERSIONS}" )
	return()
endif()

set( KDIS_VERSION ${KDIS_FIND_VERSION} )
if( NOT KDIS_FIND_QUIETLY )
	message( STATUS "Found KDIS version ${KDIS_VERSION}" )
endif()

find_path(
	KDIS_INCLUDE_DIRS
	NAMES KDIS/KDefines.h
	PATHS
		${KDIS_ROOT}
	PATH_SUFFIXES
		include
)

if( NOT KDIS_INCLUDE_DIRS )
	message( FATAL_ERROR "Couldn't find the KDIS include directory" )
	return()
endif()

if( NOT KDIS_FIND_QUIETLY )
	message( STATUS "Found KDIS: ${KDIS_INCLUDE_DIRS}" )
endif()

find_library(
	KDIS_STATIC_LIBRARY
	NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}kdis${CMAKE_STATIC_LIBRARY_SUFFIX}
	PATHS ${KDIS_PREFIX}
	PATH_SUFFIXES lib lib64
)

find_library(
	KDIS_SHARED_LIBRARY
	NAMES ${CMAKE_SHARED_LIBRARY_PREFIX}kdis${CMAKE_SHARED_LIBRARY_SUFFIX}
	PATHS ${KDIS_PREFIX}
	PATH_SUFFIXES ${DME_LIBRARY_SUFFIX} lib
	NO_CMAKE_SYSTEM_PATH
)

if( NOT KDIS_STATIC_LIBRARY AND NOT KDIS_SHARED_LIBRARY )
	message( FATAL_ERROR "Couldn't find any of the static or shared libraries for KDIS" )
	return()
endif()

if( KDIS_STATIC_LIBRARY )
	add_library( KDIS::static_library INTERFACE IMPORTED GLOBAL )
        target_link_libraries(
                KDIS::static_library
                INTERFACE
                ${KDIS_STATIC_LIBRARY}
        )
	set_target_properties(
		KDIS::static_library
			PROPERTIES
			INTERFACE_INCLUDE_DIRECTORIES ${KDIS_INCLUDE_DIRS}
			INTERFACE_COMPILE_DEFINITIONS DIS_VERSION=${KDIS_VERSION}
                        INTERFACE_IMPORTED_LOCATION ${KDIS_STATIC_LIBRARY}
	)
	if( NOT KDIS_FIND_QUIETLY )
		message( STATUS "Found KDIS: ${KDIS_STATIC_LIBRARY}" )
	endif()
	list( APPEND KDIS_LIBRARIES ${KDIS_STATIC_LIBRARY} )
endif()

if( KDIS_SHARED_LIBRARY )
	add_library( KDIS::shared_library INTERFACE IMPORTED GLOBAL )
        target_link_libraries(
                KDIS::shared_library
                INTERFACE
                ${KDIS_SHARED_LIBRARY}
        )
	set_target_properties(
		KDIS::shared_library
			PROPERTIES
			INTERFACE_INCLUDE_DIRECTORIES ${KDIS_INCLUDE_DIRS}
			INTERFACE_COMPILE_DEFINITIONS DIS_VERSION=${KDIS_VERSION}
                        INTERFACE_IMPORTED_LOCATION ${KDIS_SHARED_LIBRARY}
	)
	if( NOT KDIS_FIND_QUIETLY )
		message( STATUS "Found KDIS: ${KDIS_SHARED_LIBRARY}" )
	endif()
	list( APPEND KDIS_LIBRARIES ${KDIS_SHARED_LIBRARY} )
endif()

set( KDIS_FIND_QUIETLY True )
include( FindPackageHandleStandardArgs )
find_package_handle_standard_args(
	KDIS
	VERSION_VAR KDIS_VERSION
	REQUIRED_VARS KDIS_LIBRARIES KDIS_INCLUDE_DIRS
)
