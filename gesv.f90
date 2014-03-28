program bigMatrix

!double precision(:,:),allocatable::bigMatrix
double precision,dimension(:,:),allocatable::smallMatrix
integer i,j,k
integer n

n=3

allocate(smallMatrix(n,n))
smallMatrix(:,:)=0.d0


call random_number(smallMatrix)
do i=1,n
  smallMatrix(i,i) = smallMatrix(i,i) + 1.d0
  smallMatrix(i,i) = smallMatrix(i,i) * 1000.d0

enddo

write(*,*) smallMatrix


end program bigMatrix
