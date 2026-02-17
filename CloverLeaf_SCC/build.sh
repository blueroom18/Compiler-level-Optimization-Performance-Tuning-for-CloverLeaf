#!/bin/bash
# build.sh
# Usage: ./build.sh <COMPILER>

COMPILER=$1

if [ -z "$COMPILER" ]; then
  echo "Usage: ./build.sh <COMPILER>"
  echo "Supported: intel | gnu | aocc | hpcx | mpich | nvhpc"
  exit 1
fi

# 先加载环境 (注意必须 source)
SCRIPT_DIR=$(dirname "$(realpath "$0")")
source $SCRIPT_DIR/env.sh $COMPILER

echo "[INFO] Start compiling with $COMPILER ..."

# 编译逻辑
case "${COMPILER,,}" in
  intel)
    make COMPILER=INTEL \
      MPI_COMPILER="mpiifort -O3 -Ofast -xHost -qopt-zmm-usage=high \
                    -qopt-streaming-stores=always -funroll-loops -qopenmp \
                    -flto -no-prec-div -fp-model fast=2 -fma" \
      C_MPI_COMPILER="mpiicc -O3 -Ofast -xHost -qopt-zmm-usage=high \
                      -qopt-streaming-stores=always -funroll-loops -qopenmp \
                      -flto -no-prec-div -fp-model fast=2 -fma"
    ;;
  *)
    make COMPILER=$COMPILER
    ;;
esac

echo "[INFO] Build finished with $COMPILER"

