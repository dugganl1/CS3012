print('Hello World')

# Task: Given Binary Tree and two inputs x and y, write a program to find their LOWEST COMMON ANCESTOR


class Node:
    # Constructor
    def __init__(self, value):
        self.val = value
        self.left = None
        self.right = None


class Solve(object):
    def lowestCommonAncestor(self, root, x, y):

        if not root or y == root or x == root:
            return root

        left = self.lowestCommonAncestor(root.left, x, y)
        right = self.lowestCommonAncestor(root.right, x, y)

        if left and right:
            return root
        if left:
            return left
        elif right:
            return right
        return None
