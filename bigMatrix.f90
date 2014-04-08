program bigMatrix

use omp_lib

implicit none
integer::i,j
integer::nBig,nSmall
character(len=32)::arg
double precision::wtime,wtime2


call getarg(1,arg)
read(arg,*) nBig
call getarg(2,arg)
read(arg,*) nSmall

write(6,'("The Big matrix is  ",i6,",",i6)') nBig*nSmall,nBig*nSmall
write(6,'("  small blocks are ",i6,",",i6)') nSmall,nSmall

write(6,*)
write(6,'("Diagonalizing")')

wtime = omp_get_wtime()

!$omp parallel
!$omp do
do i=1,nBig
  call smallMatrix(i,nSmall)
enddo
!$omp end do
!$omp end parallel

wtime = omp_get_wtime() - wtime
write(6,*)
write(6,'("BigMatrix : ",f12.8," seconds")') wtime

end program bigMatrix
