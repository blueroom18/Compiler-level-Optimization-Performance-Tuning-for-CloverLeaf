!Crown Copyright 2012 AWE.
!
! This file is part of CloverLeaf.
!
! CloverLeaf is free software: you can redistribute it and/or modify it under 
! the terms of the GNU General Public License as published by the 
! Free Software Foundation, either version 3 of the License, or (at your option) 
! any later version.
!
! CloverLeaf is distributed in the hope that it will be useful, but 
! WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
! FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more 
! details.
!
! You should have received a copy of the GNU General Public License along with 
! CloverLeaf. If not, see http://www.gnu.org/licenses/.

!>  @brief Top level advection driver
!>  @author Wayne Gaudin
!>  @details Controls the advection step and invokes required communications.

MODULE advection_module

CONTAINS

  SUBROUTINE advection()

  USE mpi                    ! 添加 MPI
  USE omp_lib               ! 添加 OpenMP
  USE clover_module
  USE advec_cell_driver_module
  USE advec_mom_driver_module
  USE update_halo_module

  IMPLICIT NONE

  INTEGER :: sweep_number, direction, tile
  INTEGER :: xvel, yvel
  INTEGER :: fields(NUM_FIELDS)
  REAL(KIND=8) :: kernel_time, timer
  INTEGER :: tid, nthreads, rank, ierr

  ! ✅ 打印每个 rank 的所有线程信息
  CALL MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
  !$OMP PARALLEL PRIVATE(tid, nthreads)
    tid = omp_get_thread_num()
    nthreads = omp_get_num_threads()
    PRINT *, 'Rank', rank, 'Thread', tid, '/', nthreads
  !$OMP END PARALLEL
  
  sweep_number = 1
  IF (advect_x) THEN
    direction = g_xdir
  ELSE
    direction = g_ydir
  END IF

  xvel = g_xdir
  yvel = g_ydir

  fields = 0
  fields(FIELD_ENERGY1) = 1
  fields(FIELD_DENSITY1) = 1
  fields(FIELD_VOL_FLUX_X) = 1
  fields(FIELD_VOL_FLUX_Y) = 1
  CALL update_halo(fields, 2)

  IF (profiler_on) kernel_time = timer()

  ! ✅ 并行化 cell advection 循环
  !$OMP PARALLEL DO DEFAULT(shared) PRIVATE(tile)
  DO tile = 1, tiles_per_chunk
    CALL advec_cell_driver(tile, sweep_number, direction)
  END DO
  !$OMP END PARALLEL DO

  IF (profiler_on) profiler%cell_advection = profiler%cell_advection + (timer() - kernel_time)

  fields = 0
  fields(FIELD_DENSITY1) = 1
  fields(FIELD_ENERGY1) = 1
  fields(FIELD_XVEL1) = 1
  fields(FIELD_YVEL1) = 1
  fields(FIELD_MASS_FLUX_X) = 1
  fields(FIELD_MASS_FLUX_y) = 1
  CALL update_halo(fields, 2)

  IF (profiler_on) kernel_time = timer()

  ! ✅ 并行化 mom advection 第一次 sweep
  !$OMP PARALLEL DO DEFAULT(shared) PRIVATE(tile)
  DO tile = 1, tiles_per_chunk
    CALL advec_mom_driver(tile, xvel, direction, sweep_number)
    CALL advec_mom_driver(tile, yvel, direction, sweep_number)
  END DO
  !$OMP END PARALLEL DO

  IF (profiler_on) profiler%mom_advection = profiler%mom_advection + (timer() - kernel_time)

  sweep_number = 2
  IF (advect_x) THEN
    direction = g_ydir
  ELSE
    direction = g_xdir
  END IF

  IF (profiler_on) kernel_time = timer()

  ! ✅ 第二次 cell advection sweep 并行
  !$OMP PARALLEL DO DEFAULT(shared) PRIVATE(tile)
  DO tile = 1, tiles_per_chunk
    CALL advec_cell_driver(tile, sweep_number, direction)
  END DO
  !$OMP END PARALLEL DO

  IF (profiler_on) profiler%cell_advection = profiler%cell_advection + (timer() - kernel_time)

  fields = 0
  fields(FIELD_DENSITY1) = 1
  fields(FIELD_ENERGY1) = 1
  fields(FIELD_XVEL1) = 1
  fields(FIELD_YVEL1) = 1
  fields(FIELD_MASS_FLUX_X) = 1
  fields(FIELD_MASS_FLUX_y) = 1
  CALL update_halo(fields, 2)

  IF (profiler_on) kernel_time = timer()

  ! ✅ 第二次 mom advection sweep 并行
  !$OMP PARALLEL DO DEFAULT(shared) PRIVATE(tile)
  DO tile = 1, tiles_per_chunk
    CALL advec_mom_driver(tile, xvel, direction, sweep_number)
    CALL advec_mom_driver(tile, yvel, direction, sweep_number)
  END DO
  !$OMP END PARALLEL DO

  IF (profiler_on) profiler%mom_advection = profiler%mom_advection + (timer() - kernel_time)

END SUBROUTINE advection

END MODULE advection_module
