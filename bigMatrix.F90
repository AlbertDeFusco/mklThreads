program bigMatrix

use omp_lib
use mkl_service

implicit none
integer::i,j
integer::nBig,nSmall,mkl_threads,mkl_num_threads,mth
character(len=32)::arg,env
double precision::wtime,wtime2


call getarg(1,arg)
read(arg,*) nBig
call getarg(2,arg)
read(arg,*) nSmall

#ifdef LOCAL_MKL_TRHEADS
call getenv("MKL_THREADS",env)
read(env,*) mkl_threads
#endif


!call getenv("MKL_NUM_THREADS",env)
!read(env,*) mkl_num_threads
!call mkl_set_num_threads(mkl_num_threads)

write(6,'("The Big matrix is  ",i6,",",i6)') nBig*nSmall,nBig*nSmall
write(6,'("  small blocks are ",i6,",",i6)') nSmall,nSmall

write(6,*)
write(6,'("Diagonalizing")')

wtime = omp_get_wtime()

#ifdef OMP
!$omp parallel
!$omp do
#endif
do i=1,nBig
#ifdef LOCAL_MKL_THREADS
  mth=mkl_set_num_threads_local(mkl_threads)
#endif

  call smallMatrix(i,nSmall)

#ifdef LOCAL_MKL_THREADS
  mth=mkl_set_num_threads_local(mth)
#endif
enddo
#ifdef OMP
!$omp end do
!$omp end parallel
#endif

wtime = omp_get_wtime() - wtime
write(6,*)
write(6,'("BigMatrix : ",f12.8," seconds")') wtime

end program bigMatrix
