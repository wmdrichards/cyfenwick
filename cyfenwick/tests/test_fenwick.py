#!/usr/bin/env python

from __future__ import division

__author__ = "Will Richards"
__version__ = "0.1"
__maintainer__ = "Will Richards"
__email__ = "wmdrichards@gmail.com"
__status__ = "Beta"
__date__ = "6/18/13"

from cyfenwick import FenwickTree

import numpy as np
import unittest

class DiffusionEstimatorTest(unittest.TestCase):
    def test_integers(self):
        vals = np.random.randint(low=1, high=15, size=1000)
        ft = FenwickTree(len(vals))
        for i, v in enumerate(vals):
            ft.add_value(i, v)
        for i, v in enumerate(vals):
            self.assertEqual(ft.get_value(i), v)
        test = vals.copy()
        old = -1
        for x in range(int(ft.get_cumulative(len(vals)-1))):
            i = ft.get_index(x)
            self.assertGreaterEqual(i, old)
            test[i] -= 1
        self.assertEqual(max(test), 0)
        self.assertEqual(ft.get_index(vals[0]-0.00000001), 0)
        self.assertEqual(ft.get_index(vals[0]+0.00000001), 1)
