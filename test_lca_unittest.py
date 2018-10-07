import unittest
from LCA import *

root = Node(1)
root.left = Node(2)
root.right = Node(3)
root.left.left = Node(4)
root.left.right = Node(5)
root.right.left = Node(6)
root.right.right = Node(7)

'''
        1
      /   \
     2     3
    /\     /\
   4  5   6  7
'''


class testLCA(unittest.TestCase):
    def setUp(self):
        pass

    def test_normal_cases(self):
        # Same-level
        self.assertEqual(findLowestCommonAncestor(root, 2, 3), 1)
        self.assertEqual(findLowestCommonAncestor(root, 4, 6), 1)
        # Different-Level
        self.assertEqual(findLowestCommonAncestor(root, 2, 7), 1)
        self.assertEqual(findLowestCommonAncestor(root, 4, 3), 1)

    def test_lca_not_root(self):
        self.assertEqual(findLowestCommonAncestor(root, 6, 7), 3)
        self.assertEqual(findLowestCommonAncestor(root, 4, 5), 2)

    def test_root_as_input(self):
        self.assertEqual(findLowestCommonAncestor(root, 1, 4), 1)

    def test_lca_same_node(self):
        self.assertEqual(findLowestCommonAncestor(root, 1, 1), 1)
        self.assertEqual(findLowestCommonAncestor(root, 7, 7), 7)

    def test_only_one_exists(self):
        self.assertEqual(findLowestCommonAncestor(root, 4, 10), -1)
        self.assertEqual(findLowestCommonAncestor(root, 21, 7), -1)

    def test_neither_exist(self):
        self.assertEqual(findLowestCommonAncestor(root, 10, 8), -1)

    def test_null_tree(self):
        root = None
        self.assertEqual(findLowestCommonAncestor(root, 2, 3), -1)
        path = []
        self.assertFalse(findPath(root, path, 8))
        self.assertListEqual(path, [])

    def test_only_one_node(self):
        root = Node(10)
        self.assertEqual(findLowestCommonAncestor(root, 10, 10), 10)

    def test_path_finder(self):
        path = []
        # Root to itself
        self.assertTrue(findPath(root, path, 1))
        self.assertListEqual(path, [1])

        path = []
        # Right Side
        self.assertTrue(findPath(root, path, 7))
        self.assertListEqual(path, [1, 3, 7])

        path = []
        # Left Side
        self.assertTrue(findPath(root, path, 2))
        self.assertListEqual(path, [1, 2])

        path = []
        # No Path
        self.assertFalse(findPath(root, path, 12))
        self.assertListEqual(path, [])

        # Path not from root
        path = []
        self.assertTrue(findPath(root.right, path, 7))
        self.assertListEqual(path, [3, 7])

    print('Sucess.')


if __name__ == '__main__':
    unittest.main()
