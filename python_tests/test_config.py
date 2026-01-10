import unittest

from python_solver.config import load_config


class ConfigTests(unittest.TestCase):
    def test_config_load(self) -> None:
        cfg = load_config("tests/fixtures/sample_config.cfg")
        self.assertEqual(cfg.linear_size, 3)
        self.assertAlmostEqual(cfg.ode_t0, 0.0)
        self.assertAlmostEqual(cfg.ode_t1, 4.0)
        self.assertEqual(cfg.ode_method, "euler")


if __name__ == "__main__":
    unittest.main()
