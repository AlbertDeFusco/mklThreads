program bigMatrix

implicit none
double precision,dimension(:),allocatable::eigenvalues
integer::i,j
integer::nBig,nSmall
character(len=32)::arg
integer::t1,t2,t3,t4,clock_rate,clock_max
double precision::time


call getarg(1,arg)
read(arg,*) nBig
call getarg(2,arg)
read(arg,*) nSmall

write(6,'("The Big matrix is  ",i6,",",i6)') nBig*nSmall,nBig*nSmall
write(6,'("  small blocks are ",i6,",",i6)') nSmall,nSmall

allocate(eigenvalues(nSmall))

write(6,*)
write(6,'("Diagonalizing")')
call system_clock(t1,clock_rate,clock_max)
do i=1,nBig
  call system_clock(t2,clock_rate,clock_max)
  call smallMatrix(nSmall,eigenvalues)
  call system_clock(t3,clock_rate,clock_max)
  time=real(t3 - t2)/real(clock_rate)
  write(6,'("  block ",i6,": ",f12.8," seconds")') i,time
enddo

call system_clock(t4,clock_rate,clock_max)
time=real(t4 - t1)/real(clock_rate)
write(6,*)
write(6,'("BigMatrix : ",f12.8," seconds")') time

end program bigMatrix
