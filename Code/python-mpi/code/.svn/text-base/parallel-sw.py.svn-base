# University of Pittsburgh
# Center for Simulation and Modeling (SaM)
# Introduction to MPI with MPI4Py
# Esteban Meneses, PhD
# Description: parallel version of the Smith-Waterman algorithm to compute the longest common subsequence between two reference genetic sequences.

import sys
import numpy
import time
from mpi4py import MPI

# Function to read a genetic sequence from a text file
# Returns a numpy array with the characters in the sequence
def loadsequence(filename):
    with open (filename, "r") as myfile:
        sequence = myfile.read().replace('\n', '')
    return numpy.array(list(sequence))

# getting command parameters
if len(sys.argv) < 3:
    print ("ERROR, Usage: %s <file X> <file Y> [block size]" % (sys.argv[0]))
    exit(1)
fileX = sys.argv[1]
fileY = sys.argv[2]
if len(sys.argv) == 4:
    blocksize = int(sys.argv[3])
else:
    blocksize = 16

# loading sequences
X = loadsequence(fileX)
Y = loadsequence(fileY)

# getting basic info
comm = MPI.COMM_WORLD
rank = MPI.COMM_WORLD.Get_rank()
size = MPI.COMM_WORLD.Get_size()
name = MPI.Get_processor_name()

# getting section and boundaries for Y
section = Y.size / size
startY = section * rank
if rank == (size-1):
    endY = Y.size
else:
    endY = section * (rank + 1)
inblock = numpy.zeros(blocksize)
outblock = numpy.zeros(blocksize)

#DEBUG print "[%d] %d %d %d %d %d " % (rank, X.size, Y.size, section, startY, endY)

comm.barrier()
start = time.time()

# Smith-Waterman algorithm
L = numpy.zeros((X.size,Y.size))
for i in xrange(X.size):
    top = 0
    left = 0
    topleft = 0
  
    # receiving block from previous rank
    if i % blocksize == 0:
        if rank != 0:
            topleft = inblock[blocksize-1]
            inblock = comm.recv(source=rank-1,tag=7)
    else:
        topleft = inblock[(i-1)%blocksize]
    left = inblock[i%blocksize]

    for j in xrange(startY,endY):
        if i != 0:
            top = L[i-1,j]
        if X[i] == Y[j]:
            L[i,j] = topleft + 1
        else:
            L[i,j] = max(left,top)
        topleft = top
        left = L[i,j]
        if j == endY-1:
            outblock[i%blocksize] = L[i,j]

    # sending block to next rank
    if i % blocksize == blocksize-1 or i == X.size-1:
        if rank != size-1:
            comm.send(outblock, dest=rank+1, tag=7)

comm.barrier()
end = time.time()

if rank == size-1:
    print "Total time: %f seconds" % (end - start)
    print "Size of longest common subsequence: %d" % L[X.size-1,Y.size-1]
