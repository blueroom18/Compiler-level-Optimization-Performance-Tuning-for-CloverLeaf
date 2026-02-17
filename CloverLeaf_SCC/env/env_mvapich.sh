# 设置 GCC 15.1
export GCC_HOME=/work/sustcsc_18/gcc/15.1
export PATH=$GCC_HOME/bin:$PATH
export LD_LIBRARY_PATH=$GCC_HOME/lib64:$LD_LIBRARY_PATH

# 设置 MVAPICH (gcc15 构建的版本)
export MVAPICH_HOME=/work/sustcsc_18/compilers/mvapich/opt/mvapich/plus/4.1rc/nogpu/ucx/slurm/gcc15.1.0
export PATH=$MVAPICH_HOME/bin:$PATH
export LD_LIBRARY_PATH=$MVAPICH_HOME/lib:$LD_LIBRARY_PATH
