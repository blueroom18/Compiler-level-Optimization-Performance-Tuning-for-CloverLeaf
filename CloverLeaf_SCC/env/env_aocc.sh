# aocc_env.sh
export GCC15=/work/sustcsc_18/gcc/15.1
export CC="clang --gcc-toolchain=$GCC15"
export CXX="clang++ --gcc-toolchain=$GCC15"
export FC="flang --gcc-toolchain=$GCC15"
export LD_LIBRARY_PATH=$GCC15/lib64:$LD_LIBRARY_PATH

export PATH=/work/sustcsc_18/openmpi-aocc/bin:$PATH
export LD_LIBRARY_PATH=/work/sustcsc_18/openmpi-aocc/lib:$LD_LIBRARY_PATH
export PATH=/work/sustcsc_18/aocc-compiler-5.0.0/bin:$PATH
