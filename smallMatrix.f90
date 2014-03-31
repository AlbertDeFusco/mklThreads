subroutine smallMatrix(n,eigenvalues)

implicit none

integer,intent(IN)::n
double precision,dimension(n),intent(OUT)::eigenvalues

double precision,dimension(:,:),allocatable::Matrix
double precision,dimension(:),allocatable::work
integer i,j,stat
integer l

l=n*(3+n/2)

allocate(Matrix(n,n))
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

call dsyev('V','U',n,Matrix,n,eigenvalues,work,l,stat)


end subroutine smallMatrix
