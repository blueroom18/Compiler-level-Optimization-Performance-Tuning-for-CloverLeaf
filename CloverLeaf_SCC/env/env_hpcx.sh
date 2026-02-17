#HPCX settings
export HPCX_HOME=/work/sustcsc_18/compilers/hpcx-v2.21.3-gcc-doca_ofed-redhat8-cuda12-x86_64
export PATH=/work/sustcsc_18/gcc/15.1/bin:$PATH 
export LD_LIBRARY_PATH=/work/sustcsc_18/gcc/15.1/lib64:$LD_LIBRARY_PATH
source $HPCX_HOME/hpcx-init.sh
hpcx_load 
