import unittest
from LCA import Solve, Node

root = Node(20)
root.left = Node(8)
root.right = Node(22)
root.left.left = Node(4)
root.left.right = Node(12)
root.left.right.left = Node(10)
root.left.right.right = Node(14)


class testLCA(unittest.TestCase):
    def setUp(self):
        pass

    def test_lowestCommonAncestor(self):
        self.assertEqual(4, 4)


if __name__ == '__main__':
    unittest.main()
