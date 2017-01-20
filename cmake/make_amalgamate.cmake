macro(make_amalgamate _amalgamation_files _destination_file _source_dir )
  add_custom_command(
    OUTPUT ${_destination_file}
    COMMAND ${CMAKE_COMMAND}
    "-DSRCFILES:LIST=\"${${_amalgamation_files}}\""
    "-DSRCDIR=\"${_source_dir}\""
    "-DDSTFILE=\"${_destination_file}\""
    "-P" "${FFTW_amalgamation_script}"
    WORKING_DIRECTORY ${_source_dir}
    DEPENDS ${${_amalgamation_files}}
  )
endmacro()
