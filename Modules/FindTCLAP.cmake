
# - Try to find tclap

# Once done this will define

#  TCLAP_FOUND - System has tclap

#  TCLAP_INCLUDE_DIRS - The tclap include directories

#  TCLAP_DEFINITIONS - Compiler switches required for using tclap


find_package(PkgConfig)
pkg_check_modules(PC_TCLAP QUIET REQUIRED tclap)

find_path(TCLAP_INCLUDE_DIR 
	tclap/CmdLine.h
    HINTS ${PC_TCLAP_INCLUDEDIR}
	${PC_TCLAP_INCLUDE_DIRS}
)

add_library( TCLAP::TCLAP INTERFACE IMPORTED GLOBAL )
set_target_properties(
	TCLAP::TCLAP
		PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES ${TCLAP_INCLUDE_DIR}
)

if(NOT TCLAP_FIND_QUIETLY)
	message(STATUS "Found TCLAP: ${TCLAP_INCLUDE_DIR}")
endif()

set( TCLAP_FIND_QUIETLY True )
include( FindPackageHandleStandardArgs )
find_package_handle_standard_args(
	TCLAP
	REQUIRED_VARS TCLAP_INCLUDE_DIR
)