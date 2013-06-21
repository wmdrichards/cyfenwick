cimport numpy as cnp
cdef class FenwickTree:
    cdef cnp.double_t[:] tree
    cdef int size, len_tree
    
    cpdef add_value(self, int i, double val)
    cpdef set_value(self, int i, double val)
    cpdef double get_cumulative(self, int i)
    cpdef double get_value(self, int i)
    cpdef int get_index(self, double cumulative)
    cdef double get_total(self)

