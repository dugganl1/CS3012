# Lowest Common Ancestor Problem with DAG implementation
class DAG(object):

    class Node:
        def __init__(self, key):
            self.key = key
            self.directedTo = []

        def pointsTo(self, node):
            self.links.append(node)

    def __init__(self):
        self.graph = {}

    # Add node if it doesn't exist already
    def add_node(self, node):
        graph = self.graph

        if node in graph:
            return False

        graph[node] = []

    def add_edge(self, node_one, node_two, graph=None):
        if not graph:
            graph = self.graph

        if node_one in graph and node_two in graph:
            graph[node_one].append(node_two)
        else:
            raise ValueError("Both keys must exist")
