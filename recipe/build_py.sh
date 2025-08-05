#!/bin/bash

set -exo pipefail

echo CUDA_HOME is set to: $CUDA_HOME

echo PATH is set to: $PATH

# Workaround for fx/gltf.h:70:13: error: narrowing conversion of '-1' from 'int' to 'char' [-Wnarrowing]
if [[ "${target_platform}" == *aarch64 || "${target_platform}" == *ppc64le ]]; then
  CXXFLAGS="${CXXFLAGS} -Wno-narrowing"
fi

export CMAKE_ARGS="$CMAKE_ARGS \
    -DMOMENTUM_ENABLE_SIMD=OFF \
    -DMOMENTUM_USE_SYSTEM_PYBIND11=OFF \
    -DMOMENTUM_USE_SYSTEM_RERUN_CPP_SDK=ON"

if [[ "${target_platform}" != "${build_platform}" ]]; then
  export CMAKE_ARGS="$CMAKE_ARGS -DMOMENTUM_USE_SYSTEM_GOOGLETEST=OFF"
else
  export CMAKE_ARGS="$CMAKE_ARGS -DMOMENTUM_USE_SYSTEM_GOOGLETEST=ON"
fi

$PYTHON -m pip install . -vv --no-deps --no-build-isolation
