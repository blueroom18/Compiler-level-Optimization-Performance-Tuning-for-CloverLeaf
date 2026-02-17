#!/bin/bash
# env.sh
# Usage: source ./env.sh <COMPILER>
# 注意：要用 source ./env.sh <compiler> 才能在当前 shell 生效

COMPILER=$1

if [ -z "$COMPILER" ]; then
  echo "Usage: source ./env.sh <COMPILER>"
  echo "Supported: intel | gnu | aocc | hpcx | mpich | nvhpc"
  return 1 2>/dev/null || exit 1
fi

case "${COMPILER,,}" in
  intel)
    echo "[INFO] Loading Intel OneAPI environment..."
    source /work/share/intel/oneapi-2023.1.0/setvars.sh
    ;;

  gnu)
    echo "[INFO] Loading GNU + OpenMPI environment..."
    export PATH=/work/sustcsc_18/gcc/15.1/bin:$PATH
    export LD_LIBRARY_PATH=/work/sustcsc_18/gcc/15.1/lib64:$LD_LIBRARY_PATH

    export PATH=/work/sustcsc_18/openmpi/5.0.8-gcc15/bin:$PATH
    export LD_LIBRARY_PATH=/work/sustcsc_18/openmpi/5.0.8-gcc15/lib:$LD_LIBRARY_PATH
    ;;

  aocc)
    echo "[INFO] Loading AOCC environment..."
    export GCC15=/work/sustcsc_18/gcc/15.1
    export CC="clang --gcc-toolchain=$GCC15"
    export CXX="clang++ --gcc-toolchain=$GCC15"
    export FC="flang --gcc-toolchain=$GCC15"

    export LD_LIBRARY_PATH=$GCC15/lib64:$LD_LIBRARY_PATH
    export PATH=/work/sustcsc_18/openmpi-aocc/bin:$PATH
    export LD_LIBRARY_PATH=/work/sustcsc_18/openmpi-aocc/lib:$LD_LIBRARY_PATH
    export PATH=/work/sustcsc_18/aocc-compiler-5.0.0/bin:$PATH
    ;;

  hpcx)
    echo "[INFO] Loading HPCX environment..."
    export HPCX_HOME=/work/sustcsc_18/compilers/hpcx-v2.21.3-gcc-doca_ofed-redhat8-cuda12-x86_64
    export PATH=/work/sustcsc_18/gcc/15.1/bin:$PATH
    export LD_LIBRARY_PATH=/work/sustcsc_18/gcc/15.1/lib64:$LD_LIBRARY_PATH
    source $HPCX_HOME/hpcx-init.sh
    hpcx_load
    ;;

  mpich)
    echo "[INFO] Loading MPICH / MVAPICH environment..."
    export PATH=/work/sustcsc_18/compilers/mpich/bin:$PATH
    export LD_LIBRARY_PATH=/work/sustcsc_18/compilers/mpich/lib:$LD_LIBRARY_PATH
    export MANPATH=/work/sustcsc_18/compilers/mpich/man:$MANPATH

    export GCC_HOME=/work/sustcsc_18/gcc/15.1
    export PATH=$GCC_HOME/bin:$PATH
    export LD_LIBRARY_PATH=$GCC_HOME/lib64:$LD_LIBRARY_PATH

    export MVAPICH_HOME=/work/sustcsc_18/compilers/mvapich/opt/mvapich/plus/4.1rc/nogpu/ucx/slurm/gcc15.1.0
    export PATH=$MVAPICH_HOME/bin:$PATH
    export LD_LIBRARY_PATH=$MVAPICH_HOME/lib:$LD_LIBRARY_PATH
    ;;

  nvhpc)
    echo "[INFO] Loading NVHPC environment..."
    module load /work/sustcsc_18/nvhpc/modulefiles/nvhpc/25.5
    ;;

  *)
    echo "[ERROR] Unknown compiler: $COMPILER"
    echo "Supported: intel | gnu | aocc | hpcx | mpich | nvhpc"
    return 1 2>/dev/null || exit 1
    ;;
esac

echo "[INFO] Environment for $COMPILER loaded."

