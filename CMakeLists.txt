cmake_minimum_required (VERSION 2.6)
project (matrix C Fortran)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING
    "Compile for Debug or Release"
    FORCE)
endif()

### Source files and executables
set(SOURCES bigMatrix.F90 smallMatrix.F90 mkl_service.f90)


option(OPENMP "Enable OpenMP" OFF)
option(LOCAL_MKL_THREADS "Enable local MKL threading" OFF)
option(MKL_THREADS "Enable MKL threading" OFF)
option(ALL_BINARIES "Build all threading combinations" OFF)

set(CMAKE_Fortran_FLAGS ${CMAKE_Fortran_FLAGS} "-openmp")

if(ALL_BINARIES)

  set(Fortran_FLAGS ${CMAKE_Fortran_FLAGS})


  MESSAGE(STATUS "SERIAL BINARY")
  add_executable(bigDiag.serial ${SOURCES}) 
  unset(BLAS_LIBRARIES)
  set(BLA_VENDOR "Intel10_64lp_seq")
  find_package(BLAS REQUIRED)
  if(BLAS_FOUND)
    MESSAGE(STATUS "BLAS libraries: ${BLAS_LIBRARIES}")
    MESSAGE(STATUS "BLAS linker flags: ${BLAS_LINKER_FLAGS}")
  endif(BLAS_FOUND)
  target_link_libraries(bigDiag.serial ${BLAS_LIBRARIES} ${BLAS_LINKER_FLAGS})

  MESSAGE(STATUS "OPENMP-only BINARY")
  add_executable(bigDiag.mp ${SOURCES}) 
  set(BLA_VENDOR "Intel10_64lp_seq")
  unset(BLAS_LIBRARIES)
  find_package(BLAS REQUIRED)
  if(BLAS_FOUND)
    MESSAGE(STATUS "BLAS libraries: ${BLAS_LIBRARIES}")
    MESSAGE(STATUS "BLAS linker flags: ${BLAS_LINKER_FLAGS}")
  endif(BLAS_FOUND)
  target_link_libraries(bigDiag.mp ${BLAS_LIBRARIES} ${BLAS_LINKER_FLAGS})
  set(CMAKE_Fortran_FLAGS ${Fortran_FLAGS} "-DOMP")

  MESSAGE(STATUS "MKL THREADS BINARY")
  add_executable(bigDiag.mkl ${SOURCES}) 
  set(BLA_VENDOR "Intel10_64lp")
  unset(BLAS_LIBRARIES)
  find_package(BLAS REQUIRED)
  if(BLAS_FOUND)
    MESSAGE(STATUS "BLAS libraries: ${BLAS_LIBRARIES}")
    MESSAGE(STATUS "BLAS linker flags: ${BLAS_LINKER_FLAGS}")
  endif(BLAS_FOUND)
  target_link_libraries(bigDiag.mkl ${BLAS_LIBRARIES} ${BLAS_LINKER_FLAGS})
  set(CMAKE_Fortran_FLAGS ${Fortran_FLAGS} )

else(ALL_BINARIES)

  if(OPENMP)
    set(CMAKE_Fortran_FLAGS ${CMAKE_Fortran_FLAGS} "-DOMP")
  endif(OPENMP)

  if(MKL_THREADS)
    set(BLA_VENDOR "Intel10_64lp")
    if(LOCAL_MKL_THREADS)
      set(CMAKE_Fortran_FLAGS ${CMAKE_Fortran_FLAGS} "-DLOCAL_MKL_THREADS")
    endif(LOCAL_MKL_THREADS)
  else(MKL_THREADS)
    set(BLA_VENDOR "Intel10_64lp_seq")
  endif(MKL_THREADS)

  find_package(BLAS REQUIRED)
  if(BLAS_FOUND)
    MESSAGE(STATUS "BLAS libraries: ${BLAS_LIBRARIES}")
    MESSAGE(STATUS "BLAS linker flags: ${BLAS_LINKER_FLAGS}")
  endif(BLAS_FOUND)

  add_executable(bigDiag ${SOURCES}) 
  target_link_libraries(bigDiag ${BLAS_LIBRARIES} ${BLAS_LINKER_FLAGS})

endif(ALL_BINARIES)





