cmake_minimum_required (VERSION 2.6)
project (matrix C Fortran)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING
    "Compile GAMESS for Debug or Release"
    FORCE)
endif()

## OpenMP on by default
option(OPENMP "Enable OpenMP" OFF)

### Source files and executables
add_executable(big bigMatrix.f90 smallMatrix.f90)



if(OPENMP)
  set(CMAKE_Fortran_FLAGS ${CMAKE_CXX_FLAGS} "-openmp")
endif(OPENMP)


find_package(BLAS REQUIRED)
if(BLAS_FOUND)
  MESSAGE(STATUS "BLAS libraries: ${BLAS_LIBRARIES}")
  MESSAGE(STATUS "BLAS linker flags: ${BLAS_LINKER_FLAGS}")
  target_link_libraries(big ${BLAS_LIBRARIES} ${BLAS_LINKER_FLAGS})
endif(BLAS_FOUND)
