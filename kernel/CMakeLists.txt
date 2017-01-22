set(libkernel_source align.c alloc.c assert.c awake.c buffered.c
  cpy2d.c ct.c debug.c kalloc.c print.c timer.c cycle.h ifftw.h
)

set(libkernel_amalgamate_source
  cpy1d.c cpy2d-pair.c
  md5-1.c md5.c hash.c primes.c extract-reim.c iabs.c minmax.c
  tensor.c tensor1.c tensor2.c tensor3.c tensor4.c tensor5.c tensor7.c tensor8.c tensor9.c
  transpose.c trig.c twiddle.c tile2d.c pickdim.c
  problem.c rader.c scan.c solver.c solvtab.c stride.c
  plan.c planner.c ops.c
)


if(FFTW_USE_AMALGAMATES)
  make_amalgamate(libkernel_amalgamate_source ${CMAKE_CURRENT_BINARY_DIR}/kernel_ALL.c ${CMAKE_CURRENT_SOURCE_DIR})
  add_library(fftw_kernel_objects OBJECT
    ${CMAKE_CURRENT_BINARY_DIR}/kernel_ALL.c
    ${libkernel_source}
  )
else()
  add_library(fftw_kernel_objects OBJECT ${libkernel_source} ${libkernel_amalgamate_source})
endif()
target_include_directories(fftw_kernel_objects PRIVATE
  ${fftw_config_path}
  ${CMAKE_SOURCE_DIR}/simd
)
