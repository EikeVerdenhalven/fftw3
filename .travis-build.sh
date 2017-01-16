mkdir -p ../build-fftw
cd ../build-fftw
../cmake-3.7.2/bin/cmake -G Ninja -DFFTW_USE_NATIVE_FFTGEN=ON -DFFTW_ENABLE_TESTS=ON -DFFTW_BUILD_THREADS=ON -DFFTW_MAINTENANCE_MODE=ON -DFFTW_SIMD_USE_SSE2=ON -DCMAKE_BUILD_TYPE=Release ../fftw3
ninja
ninja fftw_tarball
ninja fftw_zip
