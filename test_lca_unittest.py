import unittest
import LCA

tree = LCA.Tree(1)
root = tree
root.insert_left(2)
root.insert_right(3)
root.left.insert_left(4)
root.left.insert_right(5)


class testLCA(unittest.TestCase):
    def setUp(self):
        pass

    def test_same_node(self):
        self.assertEqual(tree.lowestCommonAncestor(tree, tree.left, tree.left), tree.left)

    def test_lowestCommonAncestor(self):
        self.assertEqual(tree.lowestCommonAncestor(tree, tree.left, tree.right), root)

    def test_p_is_root(self):
        self.assertEqual(tree.lowestCommonAncestor(tree, root, tree.left), root)

    def test_different_levels(self):
        self.assertEqual(tree.lowestCommonAncestor(tree, tree.left.left, tree.right), root)

    def test_ancestor_not_root(self):
        self.assertEqual(tree.lowestCommonAncestor(tree, tree.left.left, tree.left.right), tree.left)

        # Test no common ancestor
        # Test that it returns None if the tree is empty
        # Test that it returns itself if there is only one element in the tree
        # Test LCA for nodes that aren't on the same tier
        # Test LCA between non-existent nodes
        # Test LCA between one existing node and one non-existent node
        # Test LCA between the root and another node
        # Test LCA when root is null
        # Test LCA of a node is itself

    print('Sucess!')


if __name__ == '__main__':
    unittest.main()
