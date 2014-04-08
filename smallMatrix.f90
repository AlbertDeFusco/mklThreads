subroutine smallMatrix(iblock,n)

use omp_lib

implicit none

integer,intent(IN)::n
double precision,dimension(:),allocatable::eigenvalues

double precision,dimension(:,:),allocatable::Matrix
double precision,dimension(:),allocatable::work
integer i,j,l,stat,iblock
double precision::wtime

l=n*(3+n/2)

allocate(Matrix(n,n),eigenvalues(n))
allocate(work(l))
Matrix(:,:)=0.d0

! fill a small matrix with random numbers
call random_number(Matrix)
do i=1,n
  Matrix(i,i) = Matrix(i,i) + 1.d0
  Matrix(i,i) = Matrix(i,i) * 1000.d0
enddo
!make it symmetric
do i=1,n
  do j=1,i
    Matrix(i,j) = Matrix(j,i)
  enddo
enddo

wtime = omp_get_wtime()
call dsyev('V','U',n,Matrix,n,eigenvalues,work,l,stat)
wtime = omp_get_wtime() - wtime
write(6,'("  block ",i6,": ",f12.8," seconds")') iblock,wtime


end subroutine smallMatrix
