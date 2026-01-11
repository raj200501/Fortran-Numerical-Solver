import unittest

from python_solver.linear_solver import conjugate_gradient, gauss_seidel, jacobi, solve_linear_system


class LinearSolverTests(unittest.TestCase):
    def setUp(self) -> None:
        self.a = [
            [3.0, -0.1, -0.2],
            [0.1, 7.0, -0.3],
            [0.3, -0.2, 10.0],
        ]
        self.b = [7.85, -19.3, 71.4]
        self.expected = [3.0, -2.5, 7.0]

    def test_lu_solution(self) -> None:
        x, info = solve_linear_system(self.a, self.b)
        self.assertEqual(info, 0)
        for xi, ei in zip(x, self.expected):
            self.assertAlmostEqual(xi, ei, places=6)

    def test_jacobi(self) -> None:
        x, _, converged = jacobi(self.a, self.b, 200, 1.0e-8)
        self.assertTrue(converged)
        for xi, ei in zip(x, self.expected):
            self.assertAlmostEqual(xi, ei, places=5)

    def test_gauss_seidel(self) -> None:
        x, _, converged = gauss_seidel(self.a, self.b, 200, 1.0e-10)
        self.assertTrue(converged)
        for xi, ei in zip(x, self.expected):
            self.assertAlmostEqual(xi, ei, places=6)

    def test_conjugate_gradient(self) -> None:
        x, _, converged = conjugate_gradient(self.a, self.b, 200, 1.0e-10)
        self.assertTrue(converged)
        for xi, ei in zip(x, self.expected):
            self.assertAlmostEqual(xi, ei, places=6)


if __name__ == "__main__":
    unittest.main()
