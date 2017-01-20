
macro(fftw_dft_codelet_referrer _vec_extension _vec_ext_header)

include(../codelets.cmake)

set(fftw_dft_simd_${_vec_extension}_codelist ${FFTW_dft_simd_codelets} codlist.c genus.c)

if(FFTW_MAINTENANCE_MODE)
  include(${CMAKE_SOURCE_DIR}/cmake/codelet_gen/dummy_codelet.cmake)
  foreach(_simd_codelet IN LISTS fftw_dft_simd_${_vec_extension}_codelist)
    fftw_gen_simd_dummy(NAME ${_simd_codelet}
      HEADER "${_vec_ext_header}"
      ORIGDIR ${FFTW_dft_simd_common_dir}
      DESTDIR ${CMAKE_CURRENT_SOURCE_DIR}
    )
  endforeach()
endif(FFTW_MAINTENANCE_MODE)

if(HAVE_${_vec_extension})
  if(FFTW_USE_AMALGAMATES)
    set(_fftw_simd_codelet_prefixes
      N1F N2F N1B N2B N2S T1F T2F T3F T1FU T1B T2B T3B T1BU T1S T2S Q1F Q1B
    )
    unset(_fftw_dft_simd_${_vec_extension}_amalgam_sources)
    foreach(_fftw_codelet_prefix IN LISTS _fftw_simd_codelet_prefixes)
     make_amalgamate(FFTW_dft_simd_${_fftw_codelet_prefix}
       ${CMAKE_CURRENT_BINARY_DIR}/dft_simd_${_vec_extension}_${_fftw_codelet_prefix}_ALL.c
       ${CMAKE_CURRENT_SOURCE_DIR}
     )
    list(APPEND _fftw_dft_simd_${_vec_extension}_amalgam_sources
      ${CMAKE_CURRENT_BINARY_DIR}/dft_simd_${_vec_extension}_${_fftw_codelet_prefix}_ALL.c
    )
    endforeach()
    add_library(fftw_dft_simd_${_vec_extension}_objects OBJECT
      ${_fftw_dft_simd_${_vec_extension}_amalgam_sources}
      codlist.c genus.c 
    )
  else() # == no amalgamates
    add_library(fftw_dft_simd_${_vec_extension}_objects OBJECT ${fftw_dft_simd_${_vec_extension}_codelist})
  endif()
  target_include_directories(fftw_dft_simd_${_vec_extension}_objects PRIVATE ${FFTW_dft_simd_includes})
  target_compile_definitions(fftw_dft_simd_${_vec_extension}_objects PRIVATE ${FFTW_${_vec_extension}_DEFINE})
  target_compile_options(fftw_dft_simd_${_vec_extension}_objects PRIVATE ${FFTW_${_vec_extension}_FLAGS})
  add_dependencies(fftw_dft_simd_${_vec_extension}_objects fftw_dft_simd_common_codelets)
endif()

endmacro()
