#!/bin/bash
# compile.sh
# Usage: ./compile.sh <COMPILER>

# 获取第一个参数作为编译器
COMPILER=$1

# 判断是否提供参数
if [ -z "$COMPILER" ]; then
  echo "Usage: $0 <COMPILER>"
  exit 1
fi

# 根据编译器名称选择编译方式
if [[ "$COMPILER" == "intel" || "$COMPILER" == "INTEL" ]]; then
  make COMPILER=INTEL MPI_COMPILER="mpiifort -O3 -Ofast -xHost -qopt-zmm-usage=high -qopt-streaming-stores=always -funroll-loops -qopenmp -flto -no-prec-div -fp-model fast=2 -fma" C_MPI_COMPILER="mpiicc -O3 -Ofast -xHost -qopt-zmm-usage=high -qopt-streaming-stores=always -funroll-loops -qopenmp -flto -no-prec-div -fp-model fast=2 -fma"
else
  make COMPILER=$COMPILER
fi

