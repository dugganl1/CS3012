print('Hello World')

# Task: Given Binary Tree and two inputs x and y, write a program to find their LOWEST COMMON ANCESTOR


class Node(object):
    # Constructor
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None


class Solve(object):
    def lowestCommonAncestor(self, root, p, q):

        if root is None:
            return None

        if root == p or root == q:
            return root

        left = self.lowestCommonAncestor(root.left, p, q)
        right = self.lowestCommonAncestor(root.right, p, q)

        if left is not None and right is not None:
            return root
        if left is None:
            return right
        else:
            return left
