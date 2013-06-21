#cython: wraparound=False

import numpy as np
cimport numpy as cnp
from libc.math cimport pow, log2

cdef class FenwickTree:
    '''
    Defined in pxd:
    cdef cnp.double_t[:] tree
    cdef int size, len_tree
    '''
    
    def __init__(self, size):
        self.tree = np.zeros(size, dtype=np.double)
        self.size = 0
        self.len_tree = size
        
    def __cinit__(self, int size):
        self.tree = np.zeros(size, dtype=np.double)
        self.size = 0
        self.len_tree = size
    
    cpdef add_value(self, int i, double val):
        self.size = max(self.size, i)
        i += 1
        while i <= self.len_tree:
            self.tree[i-1] += val
            i += i & -i
            
    cpdef set_value(self, int i, double val):
        self.add_value(i, val - self.get_value(i))
    
    cpdef double get_cumulative(self, int i):
        i += 1
        cdef double s = 0
        while i > 0:
            s += self.tree[i-1]
            i = i & i-1
        return s
    
    cpdef double get_value(self, int i):
        i += 1
        cdef double val = self.tree[i-1]
        cdef int parent = i & i-1
        i -= 1
        while parent != i:
            val -= self.tree[i-1]
            i = i & i-1
        return val
    
    cpdef int get_index(self, double cumulative):
        cdef int i = 0
        cdef int m = <int> pow(2,<int> log2(self.size))
        cdef int test_i = 0
        cdef double cf = 0
        
        while m != 0:
            test_i = i + m
            if test_i - 1 <= self.size:
                cf = self.tree[test_i - 1]
                if cumulative >= cf:
                    i = test_i
                    cumulative -= cf
            m /= 2 
        return i
    
    cdef double get_total(self):
        return self.get_cumulative(self.size)
    
    @property
    def total(self):
        return self.get_cumulative(self.size)
