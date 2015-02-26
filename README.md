# mklThreads
Mixing MKL threads with OpenMP

My goal here is to explore the relationship between openMP threads
and MKL threads that in essence diagonalized a blocked matrix where
the blocks would be created by each openMP thread on-the-fly.

Questions:
 - Is there a performance sweet-spot between OMP_NUM_THREADS and MKL_NUM_THREADS?
 - How do I deal with nested threads?
 - How well does this scale with number of threads?
