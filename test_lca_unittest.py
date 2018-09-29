import unittest
from LCA import addOne


class testLCA(unittest.TestCase):
    def setUp(self):
        pass

    def test_addOne(self):
        self.assertEqual(addOne(3), 4)


if __name__ == '__main__':
    unittest.main()
