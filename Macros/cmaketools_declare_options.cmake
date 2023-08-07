function( cmaketools_declare_options )
    # CMake options
    option( ${PROJECT_NAME}_FORCE_32BITS        "Force 32 bits architecture"                       OFF )
    option( ${PROJECT_NAME}_USE_GPROF           "Use G profiler"                                   OFF )
    option( ${PROJECT_NAME}_CMAKE_DEBUG         "Turn ON/OFF CMake debugging messsages"            OFF )
    option( ${PROJECT_NAME}_GENERATE_DOXYGEN    "Turn ON/OFF to generate Doxygen documentation"    ON  )
    option( ${PROJECT_NAME}_WERROR              "Turn ON/OFF the -Werror"                          OFF )
    option( ${PROJECT_NAME}_WEXTRA              "Turn ON/OFF the -Wextra"                          ON  )
endfunction()