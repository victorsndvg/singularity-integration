# University of Pittsburgh
# Center for Simulation and Modeling (SaM)
# Introduction to MPI with MPI4Py
# Esteban Meneses, PhD
# Description: Smith-Waterman algorithm to compute the longest common subsequence between two reference genetic sequences.

import sys
import numpy
import time

# Function to read a genetic sequence from a text file
# Returns a numpy array with the characters in the sequence
def loadsequence(filename):
    with open (filename, "r") as myfile:
        sequence = myfile.read().replace('\n', '')
    return numpy.array(list(sequence))

# getting command parameters
if len(sys.argv) < 3:
    print ("ERROR, Usage: %s <file X> <file Y>" % (sys.argv[0]))
    exit(1)
fileX = sys.argv[1]
fileY = sys.argv[2]

# loading sequences
X = loadsequence(fileX)
Y = loadsequence(fileY)

start = time.time()

# Smith-Waterman algorithm
L = numpy.zeros((X.size,Y.size))
for i in xrange(X.size):
    top = 0
    left = 0
    topleft = 0
    for j in xrange(Y.size):
        if i != 0:
            top = L[i-1,j]
        if X[i] == Y[j]:
            L[i,j] = topleft + 1
        else:
            L[i,j] = max(left,top)
        topleft = top
        left = L[i,j]

end = time.time()

print "Total time: %f seconds" % (end - start)
print "Size of longest common subsequence: %d" % L[X.size-1,Y.size-1]
