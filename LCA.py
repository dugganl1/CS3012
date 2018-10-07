# Task: Given Binary Tree and two inputs x and y, write a program to find their LOWEST COMMON ANCESTOR
#GeeksForGeeks implementation
class Node(object):
    # Constructor
    def __init__(self, key):
        self.key = key
        self.left = None
        self.right = None


def findPath(root, path, k):
    if root is None:
        return False

    # Store node in path vector, Removed if not in path from root to k
    path.append(root.key)

    # see if k is the same as the root's key
    if root.key == k:
        return True

    # Check if in left or right subtree
    if(root.left is not None and findPath(root.left, path, k)) or (root.right is not None and findPath(root.right, path, k)):
        return True

# If it gets this far, it means its not present so lets remove the root from the path and return False
    path.pop()
    return False


def findLowestCommonAncestor(root, p, q):
    # store paths
    path1 = []
    path2 = []

    if not findPath(root, path1, p) or not findPath(root, path2, q):
        return -1

    # Compare paths to get first different value, and return the node index before this
    i = 0
    while(i < len(path1) and i < len(path2)):
        if path1[i] != path2[i]:
            break
        i += 1
    return path1[i - 1]
