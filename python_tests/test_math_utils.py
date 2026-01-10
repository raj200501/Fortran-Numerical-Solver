import math
import unittest

from python_solver.integration import adaptive_trapezoidal, simpson, trapezoidal
from python_solver.interpolation import lagrange_interpolate, linear_interpolate, linspace
from python_solver.optimization import backtracking_line_search, gradient_descent, momentum_descent
from python_solver.root_finding import bisection, newton, secant
from python_solver.statistics import covariance_matrix, mean_vector, stddev_vector, variance_vector
from python_solver.time_series import (
    exponential_smoothing,
    mean_absolute_error,
    mean_squared_error,
    moving_average,
    root_mean_squared_error,
)


class RootFindingTests(unittest.TestCase):
    def test_root_finding(self) -> None:
        f = lambda x: x * x - 2.0
        df = lambda x: 2.0 * x
        root, _, converged = bisection(f, 0.0, 2.0, 1.0e-8, 100)
        self.assertTrue(converged)
        self.assertAlmostEqual(root, math.sqrt(2), places=6)
        root, _, converged = newton(f, df, 1.0, 1.0e-10, 50)
        self.assertTrue(converged)
        self.assertAlmostEqual(root, math.sqrt(2), places=8)
        root, _, converged = secant(f, 1.0, 2.0, 1.0e-10, 50)
        self.assertTrue(converged)
        self.assertAlmostEqual(root, math.sqrt(2), places=6)


class IntegrationTests(unittest.TestCase):
    def test_integration(self) -> None:
        f = lambda x: x * x
        self.assertAlmostEqual(trapezoidal(f, 0.0, 1.0, 1000), 1.0 / 3.0, places=4)
        self.assertAlmostEqual(simpson(f, 0.0, 1.0, 100), 1.0 / 3.0, places=6)
        area, _, converged = adaptive_trapezoidal(f, 0.0, 1.0, 1.0e-6, 20)
        self.assertTrue(converged)
        self.assertAlmostEqual(area, 1.0 / 3.0, places=4)


class OptimizationTests(unittest.TestCase):
    def test_optimization(self) -> None:
        f = lambda x: (x - 2.0) ** 2
        g = lambda x: 2.0 * (x - 2.0)
        x_opt, _, converged = gradient_descent(f, g, 5.0, 0.1, 1.0e-8, 200)
        self.assertTrue(converged)
        self.assertAlmostEqual(x_opt, 2.0, places=3)
        x_opt, _, converged = momentum_descent(f, g, -4.0, 0.1, 0.9, 1.0e-6, 300)
        self.assertTrue(converged)
        self.assertAlmostEqual(x_opt, 2.0, places=3)
        alpha = backtracking_line_search(f, g, 0.0, -g(0.0), 1.0, 0.5, 1.0e-4)
        self.assertGreater(alpha, 0.0)


class StatisticsInterpolationTests(unittest.TestCase):
    def test_statistics(self) -> None:
        x = [1.0, 2.0, 3.0, 4.0]
        self.assertAlmostEqual(mean_vector(x), 2.5)
        self.assertAlmostEqual(variance_vector(x), 1.25)
        self.assertAlmostEqual(stddev_vector(x), math.sqrt(1.25))
        data = [[1.0, 2.0], [2.0, 4.0], [3.0, 6.0]]
        cov = covariance_matrix(data)
        self.assertAlmostEqual(cov[0][0], 1.0)
        self.assertAlmostEqual(cov[0][1], 2.0)

    def test_interpolation(self) -> None:
        self.assertAlmostEqual(linear_interpolate(0.0, 0.0, 10.0, 20.0, 2.5), 5.0)
        self.assertAlmostEqual(lagrange_interpolate([0.0, 1.0, 2.0], [1.0, 3.0, 5.0], 1.5), 4.0)
        self.assertEqual(linspace(0.0, 1.0, 3), [0.0, 0.5, 1.0])


class TimeSeriesTests(unittest.TestCase):
    def test_time_series(self) -> None:
        x = [1.0, 2.0, 3.0, 4.0, 5.0]
        self.assertEqual(moving_average(x, 3), [1.0, 1.5, 2.0, 3.0, 4.0])
        smoothed = exponential_smoothing(x, 0.5)
        self.assertAlmostEqual(smoothed[1], 1.5)
        self.assertAlmostEqual(mean_absolute_error(x, [v + 1 for v in x]), 1.0)
        self.assertAlmostEqual(mean_squared_error(x, [v + 1 for v in x]), 1.0)
        self.assertAlmostEqual(root_mean_squared_error(x, [v + 1 for v in x]), 1.0)


if __name__ == "__main__":
    unittest.main()
