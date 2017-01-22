set(libapi_execute_source
  execute-dft-c2r.c
  execute-dft-r2c.c
  execute-dft.c
  execute-r2r.c
  execute-split-dft-c2r.c
  execute-split-dft-r2c.c
  execute-split-dft.c
  execute.c
)

set(libapi_wisdom_source
  forget-wisdom.c
  import-system-wisdom.c
  import-wisdom-from-file.c
  import-wisdom-from-string.c
  export-wisdom-to-file.c
  export-wisdom-to-string.c
)

set(libapi_plandft_source
  apiplan.c
  configure.c
  flops.c
  plan-dft-1d.c
  plan-dft-2d.c
  plan-dft-3d.c
  plan-dft-c2r-1d.c
  plan-dft-c2r-2d.c
  plan-dft-c2r-3d.c
  plan-dft-c2r.c
  plan-dft-r2c-1d.c
  plan-dft-r2c-2d.c
  plan-dft-r2c-3d.c
  plan-dft-r2c.c
  plan-dft.c
  plan-many-dft.c
  plan-guru-dft-c2r.c
  plan-guru-dft-r2c.c
  plan-guru-dft.c
  plan-guru-r2r.c
  plan-guru-split-dft-c2r.c
  plan-guru-split-dft-r2c.c
  plan-guru-split-dft.c
  plan-r2r-1d.c
  plan-r2r-2d.c
  plan-r2r-3d.c
  plan-r2r.c
  plan-many-r2r.c
  plan-many-dft-c2r.c
  plan-many-dft-r2c.c
  the-planner.c
)

set(libapi_planguru64_source
  plan-guru64-dft-c2r.c
  plan-guru64-dft-r2c.c
  plan-guru64-dft.c
  plan-guru64-r2r.c
  plan-guru64-split-dft-c2r.c
  plan-guru64-split-dft-r2c.c
  plan-guru64-split-dft.c
)

set(libapi_api_source

  f77api.c

  malloc.c
  map-r2r-kind.c
  mapflags.c
  mkprinter-file.c
  mkprinter-str.c
  mktensor-iodims.c
  mktensor-iodims64.c
  mktensor-rowmajor.c
  export-wisdom.c
  import-wisdom.c
  print-plan.c
  rdft2-pad.c

  version.c
)

if(FFTW_USE_AMALGAMATES)
  include(${CMAKE_SOURCE_DIR}/cmake/make_amalgamate.cmake)

  make_amalgamate(libapi_planguru64_source ${CMAKE_CURRENT_BINARY_DIR}/api_planguru64_ALL.c ${CMAKE_CURRENT_SOURCE_DIR})
  make_amalgamate(libapi_plandft_source ${CMAKE_CURRENT_BINARY_DIR}/api_plandft_ALL.c ${CMAKE_CURRENT_SOURCE_DIR})
  make_amalgamate(libapi_wisdom_source ${CMAKE_CURRENT_BINARY_DIR}/api_wisdom_ALL.c ${CMAKE_CURRENT_SOURCE_DIR})
  make_amalgamate(libapi_execute_source ${CMAKE_CURRENT_BINARY_DIR}/api_execute_ALL.c ${CMAKE_CURRENT_SOURCE_DIR})

  add_library(fftw_api_objects OBJECT
    ${CMAKE_CURRENT_BINARY_DIR}/api_planguru64_ALL.c
    ${CMAKE_CURRENT_BINARY_DIR}/api_plandft_ALL.c
    ${CMAKE_CURRENT_BINARY_DIR}/api_wisdom_ALL.c
    ${CMAKE_CURRENT_BINARY_DIR}/api_execute_ALL.c
    ${libapi_api_source}
  )
  target_include_directories(fftw_api_objects PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
else()
  add_library(fftw_api_objects OBJECT
    ${libapi_api_source}
    ${libapi_planguru64_source}
    ${libapi_plandft_source}
    ${libapi_wisdom_source}
    ${libapi_execute_source}
)
endif()
target_include_directories(fftw_api_objects PRIVATE
    ${fftw_config_path}
    ${CMAKE_SOURCE_DIR}/kernel
    ${CMAKE_SOURCE_DIR}/dft
    ${CMAKE_SOURCE_DIR}/rdft
    ${CMAKE_SOURCE_DIR}/reodft
)
