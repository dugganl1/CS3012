import unittest
from LCA import Solve, Node

root = Node(8)
root.left = Node(12)
root.right = Node(21)
root.left.left = Node(14)
root.left.right = Node(7)
root.left.right.left = Node(9)
root.left.right.right = Node(3)


class testLCA(unittest.TestCase):
    def setUp(self):
        pass

    def test_lowestCommonAncestor(self):
        self.assertEqual(Solve().lowestCommonAncestor(root, root.left.right, root.right).val, 8)


if __name__ == '__main__':
    unittest.main()
