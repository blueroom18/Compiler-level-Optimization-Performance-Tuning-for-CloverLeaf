# CloverLeaf_ref


## Instructions for my submission
尊敬的评委、学长，首先我可能要先道个歉，因为这是我第一次参赛，经验不足，且因为时间和其它要务的原因比赛的报告和提交可能不是非常详细且正确，我们小组主要进行了对整个编译过程程度尝试和小幅修改，并没有做什么比对试验或是其它Cloverleaf文档中要求的一些性能测试，所以我的报告可能极其简陋，希望您不要过度在意，请正常给分，不要影响心情。以下我将对这个提交目录做一些说明。

### How to check the results
如您所见，比赛的所有编译器的结果就在目录的results中，我在results中主要存放了几个编译器文件夹，每个编译器文件夹存放了在这个编译环境中编译好的clover_leaf，提交文件job.<compiler>.slurm，job.lsf，Makeflile(基本没有修改，复现测试也用不到，如有疑惑，敬请查看)，cases，最好测试对应的.err & .out & clover1.out & clover2.out。为了方便您进行运行复现的测试，您需要在对应的results/<compiler>目录下执行sbatch指令就可以直接进行测试，但注意，输出文件可能会覆盖我之前放进去的结果，所以您可以对比<new_job>.out和已有.out文件。
但如果您想复现获得clover_leaf的过程，这可能有些许麻烦，你需要退回到提交的根目录中，执行chmod +x build.sh 和 ./build.sh "<name of compiler in lowercase>"，这会自动执行引入环境变量和编译链接等过程生成clover_leaf，根目录中也有每个编译器的提交文件job.<compiler>.slurm，你可以在根目录中直接使用sbatch并查看结果而不是在result目录中去进行操作。

这次制作非常粗糙，请评委、学长多多包涵！


This is the reference version of CloverLeaf version 1.3. 

## Release Notes

### Version 1.3

CloverLeaf 1.3 contains a number of optimisations over previous releases.
These include a number of loop fusion optimisations and the use of scalar variables over work arrays.
Overall this improves cache efficiency.

This version also contains some support for explicit tiling.
This is activated through the two input deck parameters:

* `tiles_per_chunk` To specify how many tiles per MPI ranks there are.
* `tiles_per_problem` To specify how many global tiles there are, this is rounded down to be an even number per MPI rank.


## Performance

Expected performance is give below.

If you do not see this performance, or you see variability, then is it recommended that you check MPI task placement and OpenMP thread affinities, because it is essential these are pinned and placed optimally to obtain best performance.

Note that performance can depend on compiler (brand and release), memory speed, system settings (e.g. turbo, huge pages), system load etc. 

### Performance Table

| Test Problem  | Time                         | Time                        | Time                        |
| ------------- |:----------------------------:|:---------------------------:|:---------------------------:|
| Hardware      |  E5-2670 0 @ 2.60GHz Core    | E5-2670 0 @ 2.60GHz Node    | E5-2698 v3 @ 2.30GHz Node   |
| Options       |  make COMPILER=INTEL         | make COMPILER=INTEL         | make COMPILER=CRAY          |
| Options       |  mpirun -np 1                | mpirun -np 16               | aprun -n4 -N4 -d8           |
| 2             | 20.0                         | 2.5                         | 0.9                         |
| 3             | 960.0                        | 100.0                       |                             |
| 4             | 460.0                        | 40.0                        | 23.44                       |
| 5             | 13000.0                      | 1700.0                      |                             |

### Weak Scaling - Test 4

| Node Count | Time         |
| ---------- |:------------:|
| 1          |   40.0       |
| 2          |              |
| 4          |              |
| 8          |              |
| 16         |              |


### Strong Scaling - Test 5

| Node Count | Time          | Speed Up |
| ---------- |:-------------:|:--------:|
| 1          |   1700        |  1.0     |
| 2          |               |          |
| 4          |               |          |
| 8          |               |          |
| 16         |               |          |


