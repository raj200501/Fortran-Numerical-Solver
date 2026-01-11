import math
import unittest

from python_solver.matrix_ops import matmul, transpose, trace, frobenius_norm
from python_solver.ode import solve_ivp


class MatrixOpsTests(unittest.TestCase):
    def test_matrix_ops(self) -> None:
        a = [[4.0, 7.0], [2.0, 6.0]]
        b = [[1.0, 2.0], [3.0, 4.0]]
        c = matmul(a, b)
        self.assertAlmostEqual(c[0][0], 25.0)
        self.assertAlmostEqual(c[0][1], 36.0)
        at = transpose(a)
        self.assertEqual(at[1][0], 7.0)
        self.assertAlmostEqual(trace(a), 10.0)
        self.assertAlmostEqual(frobenius_norm(a), math.sqrt(sum(val * val for row in a for val in row)))


class ODETests(unittest.TestCase):
    def test_rk4_exp(self) -> None:
        def rhs(t, y):
            return [y[0]]

        t, y = solve_ivp(rhs, 0.0, 1.0, [1.0], 0.1, "rk4")
        self.assertAlmostEqual(y[0][0], 1.0)
        self.assertAlmostEqual(y[-1][0], math.e, places=3)


if __name__ == "__main__":
    unittest.main()
