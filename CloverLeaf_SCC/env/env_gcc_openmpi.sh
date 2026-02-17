#!/bin/bash
# GNU Settings

# 设置 GCC 路径
export PATH=/work/sustcsc_18/gcc/15.1/bin:$PATH
export LD_LIBRARY_PATH=/work/sustcsc_18/gcc/15.1/lib64:$LD_LIBRARY_PATH

# 设置 OpenMPI 路径（与该 GCC 配套）
export PATH=/work/sustcsc_18/openmpi/5.0.8-gcc15/bin:$PATH
export LD_LIBRARY_PATH=/work/sustcsc_18/openmpi/5.0.8-gcc15/lib:$LD_LIBRARY_PATH
