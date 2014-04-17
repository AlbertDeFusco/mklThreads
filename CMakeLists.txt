cmake_minimum_required (VERSION 2.6)
project (matrix C Fortran)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING
    "Compile for Debug or Release"
    FORCE)
endif()

### Source files and executables
set(SOURCES bigMatrix.F90 smallMatrix.F90)


option(OPENMP "Enable OpenMP" OFF)
option(LOCAL_MKL_THREADS "Enable local MKL threading" OFF)
option(MKL_THREADS "Enable MKL threading" OFF)
option(ALL_BINARIES "Build all threading combinations" OFF)

set(CMAKE_Fortran_FLAGS ${CMAKE_Fortran_FLAGS} "-openmp")

if(LOCAL_MKL_THREADS)
  file(APPEND SOURCES mkl_service.f90)
endif(LOCAL_MKL_THREADS)


if(ALL_BINARIES)

  set(Fortran_FLAGS ${CMAKE_Fortran_FLAGS})


  MESSAGE("")
  MESSAGE(STATUS "SERIAL BINARY")
  add_executable(bigDiag.serial ${SOURCES}) 
  set(BLAS_LIBRARIES
    "/opt/sam/intel/composer_xe_2013.0.079/mkl/lib/intel64/libmkl_intel_lp64.so;/opt/sam/intel/composer_xe_2013.0.079/mkl/lib/intel64/libmkl_sequential.so;/opt/sam/intel/composer_xe_2013.0.079/mkl/lib/intel64/libmkl_core.so")
  MESSAGE(STATUS "BLAS libraries: ${BLAS_LIBRARIES}")
  target_link_libraries(bigDiag.serial ${BLAS_LIBRARIES} ${BLAS_LINKER_FLAGS})

  MESSAGE("")
  MESSAGE(STATUS "OPENMP-only BINARY")
  add_executable(bigDiag.mp ${SOURCES}) 
  MESSAGE(STATUS "BLAS libraries: ${BLAS_LIBRARIES}")
  target_link_libraries(bigDiag.mp ${BLAS_LIBRARIES} ${BLAS_LINKER_FLAGS})
  set_target_properties(bigDiag.mp PROPERTIES COMPILE_FLAGS "-DOMP" )

  MESSAGE("")
  MESSAGE(STATUS "MKL THREADS BINARY")
  add_executable(bigDiag.mkl ${SOURCES}) 
  set(BLAS_LIBRARIES
    "/opt/sam/intel/composer_xe_2013.0.079/mkl/lib/intel64/libmkl_intel_lp64.so;/opt/sam/intel/composer_xe_2013.0.079/mkl/lib/intel64/libmkl_intel_thread.so;/opt/sam/intel/composer_xe_2013.0.079/mkl/lib/intel64/libmkl_core.so;/opt/sam/intel/composer_xe_2013.0.079/compiler/lib/intel64/libiomp5.so")
  MESSAGE(STATUS "BLAS libraries: ${BLAS_LIBRARIES}")
  target_link_libraries(bigDiag.mkl ${BLAS_LIBRARIES} ${BLAS_LINKER_FLAGS})

  MESSAGE("")
  MESSAGE(STATUS "OPENMP / MKL THREADS BINARY")
  add_executable(bigDiag.mpmkl ${SOURCES}) 
  MESSAGE(STATUS "BLAS libraries: ${BLAS_LIBRARIES}")
  target_link_libraries(bigDiag.mpmkl ${BLAS_LIBRARIES} ${BLAS_LINKER_FLAGS})
  set_target_properties(bigDiag.mpmkl PROPERTIES COMPILE_FLAGS "-DOMP" )

else(ALL_BINARIES)

  if(OPENMP)
    add_definitions(-DOMP)
  endif(OPENMP)

  if(MKL_THREADS)
    set(BLA_VENDOR "Intel10_64lp")
    if(LOCAL_MKL_THREADS)
      add_definitions(-DLOCAL_MKL_THREADS)
      #set(CMAKE_Fortran_FLAGS ${CMAKE_Fortran_FLAGS} "-DLOCAL_MKL_THREADS")
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





