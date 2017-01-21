include(codelets.cmake)

if(FFTW_MAINTENANCE_MODE)
  include(${CMAKE_SOURCE_DIR}/cmake/codelet_gen/make_codelets.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/codelet_gen/make_codlist.cmake)

  fftw_gen_codlist(
    XRENAME X
    SOLVTAB "X(solvtab_rdft_r2cf)"
    CODELETS ${fftw_r2cf_scalar_codelets_source}
    OUTPUT_FILE "${CMAKE_CURRENT_SOURCE_DIR}/codlist.c"
  )
  set(FLAGS_R2CF ${RDFT_FLAGS_COMMON})
  set(FLAGS_HF ${RDFT_FLAGS_COMMON})
  set(FLAGS_HF2 ${RDFT_FLAGS_COMMON} -twiddle-log3 -precompute-twiddles)
  set(FLAGS_HC2CF ${RDFT_FLAGS_COMMON})
  set(FLAGS_HC2CF2 ${RDFT_FLAGS_COMMON} -twiddle-log3 -precompute-twiddles)
  set(FLAGS_R2CFII ${RDFT_FLAGS_COMMON})

  genfft_make_codelets(
    NAME r2cf
    SOURCES ${R2CF}
    GENERATOR gen_r2cf
    ARGS ${FLAGS_R2CF} "-include" "\"r2cf.h\""
    SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}
    BINDIR ${CMAKE_CURRENT_BINARY_DIR}
    PRELUDE ${FFTW_rdft_prelude}
  )
  genfft_make_codelets(
    NAME hf
    SOURCES ${HF}
    GENERATOR gen_hc2hc
    ARGS ${FLAGS_HF} "-dit" "-include" "\"hf.h\""
    SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}
    BINDIR ${CMAKE_CURRENT_BINARY_DIR}
    PRELUDE ${FFTW_rdft_prelude}
  )
  genfft_make_codelets(
    NAME hf2
    SOURCES ${HF2}
    GENERATOR gen_hc2hc
    ARGS ${FLAGS_HF2} "-dit" "-include" "\"hf.h\""
    SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}
    BINDIR ${CMAKE_CURRENT_BINARY_DIR}
    PRELUDE ${FFTW_rdft_prelude}
  )
  genfft_make_codelets(
    NAME r2cfII
    SOURCES ${R2CFII}
    GENERATOR gen_r2cf
    ARGS ${FLAGS_R2CF} "-dft-II" "-include" "\"r2cfII.h\""
    SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}
    BINDIR ${CMAKE_CURRENT_BINARY_DIR}
    PRELUDE ${FFTW_rdft_prelude}
  )
  genfft_make_codelets(
    NAME hc2cf
    SOURCES ${HC2CF}
    GENERATOR gen_hc2c
    ARGS ${FLAGS_HC2CF} "-dit" "-include" "\"hc2cf.h\""
    SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}
    BINDIR ${CMAKE_CURRENT_BINARY_DIR}
    PRELUDE ${FFTW_rdft_prelude}
  )
  genfft_make_codelets(
    NAME hc2cf2
    SOURCES ${HC2CF2}
    GENERATOR gen_hc2c
    ARGS ${FLAGS_HC2CF2} "-dit" "-include" "\"hc2cf.h\""
    SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}
    BINDIR ${CMAKE_CURRENT_BINARY_DIR}
    PRELUDE ${FFTW_rdft_prelude}
  )
  genfft_make_codelets(
    NAME hc2cfdft
    SOURCES ${HC2CFDFT}
    GENERATOR gen_hc2cdft
    ARGS ${FLAGS_HC2CF2} "-dit" "-include" "\"hc2cf.h\""
    SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}
    BINDIR ${CMAKE_CURRENT_BINARY_DIR}
    PRELUDE ${FFTW_rdft_prelude}
  )
  genfft_make_codelets(
    NAME hc2cfdft2
    SOURCES ${HC2CFDFT2}
    GENERATOR gen_hc2cdft
    ARGS ${FLAGS_HC2CF2} "-dit" "-include" "\"hc2cf.h\""
    SRCDIR ${CMAKE_CURRENT_SOURCE_DIR}
    BINDIR ${CMAKE_CURRENT_BINARY_DIR}
    PRELUDE ${FFTW_rdft_prelude}
  )

endif(FFTW_MAINTENANCE_MODE)

if(FFTW_USE_AMALGAMATES)
  set(fftw_rdft_scalar_r2cf_groups
    R2CF HF HF2 R2CFII HC2CF HC2CFDFT HC2CF2 HC2CFDFT2
  )
  include(${CMAKE_SOURCE_DIR}/cmake/make_amalgamate.cmake)
  unset(fftw_rdft_scalar_r2cf_amalgamates)
  foreach(r2cf_group IN LISTS fftw_rdft_scalar_r2cf_groups)
    make_amalgamate(${r2cf_group}
      ${CMAKE_CURRENT_BINARY_DIR}/rdft_scalar_r2cf_${r2cf_group}_ALL.c
      ${CMAKE_CURRENT_SOURCE_DIR}
    )
    list(APPEND fftw_rdft_scalar_r2cf_amalgamates
      ${CMAKE_CURRENT_BINARY_DIR}/rdft_scalar_r2cf_${r2cf_group}_ALL.c
    )
  endforeach()
  add_library(fftw_rdft_scalar_r2cf_objects OBJECT
    ${fftw_rdft_scalar_r2cf_amalgamates}
    codlist.c
  )
else()
  add_library(fftw_rdft_scalar_r2cf_objects OBJECT ${fftw_r2cf_scalar_codelets_source} codlist.c)
endif()
target_include_directories(fftw_rdft_scalar_r2cf_objects PRIVATE
    ${fftw_config_path}
    ${CMAKE_SOURCE_DIR}/kernel
    ${CMAKE_SOURCE_DIR}/rdft
    ${CMAKE_SOURCE_DIR}/rdft/scalar
)
