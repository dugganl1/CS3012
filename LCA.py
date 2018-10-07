# Task: Given Binary Tree and two inputs x and y, write a program to find their LOWEST COMMON ANCESTOR


class Tree:
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None

    def insert_left(self, x):
        if self.left is None:
            self.left = Tree(x)
        else:
            new_node = Tree(x)
            new_node.left = self.left
            self.left = new_node

    def insert_right(self, x):
        if self.right is None:
            self.right = Tree(x)
        else:
            new_node = Tree(x)
            new_node.right = self.right
            self.right = new_node

    def lowestCommonAncestor(self, root, p, q):
        source = self

        if p is None or q is None:
            return self.ancestor(source.p) or self.ancestor(source.q)

        if self.ancestor(source, p) is None:
            print('One or both nodes are not part of the tree')

        if self.ancestor(source, q) is None:
            print('One or both nodes are not part of the tree')

        if(p == q):
            print('Cant compare the same node')

        if root in [None, p, q]:
            return root

        left, right = (self.lowestCommonAncestor(kid, p, q) for kid in (root.left, root.right))

        if left and right:
            return root
        else:
            return left or right

    def ancestor(self, root, node):
        if root is not None:
            if root == node:
                return node
            if root.left is not None and root.left == node:
                return root
            if root.right is not None and root.right == node:
                return root
            elif root:
                return self.ancestor(root.left, node) or self.ancestor(root.right, node)
            else:
                return None


'''
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
'''
