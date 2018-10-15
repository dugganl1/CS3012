import unittest
from DAG import DAG

graph = DAG()

"""
For testing purposes I'm going to contruct the following DAG (direction down)
          1
       /    \
      2      3
     / \     /\
    4   5   6  7
       /|\   \
      8 9 10  11
"""


class testLCA_DAG(unittest.TestCase):
    def setUp(self):
        pass

    def test_adding_nodes(self):
        # Check it adds a node
        graph.add_node(1)
        self.assertEqual(graph.graph, {1: []})
        # Check it doesn't add a node if it already exists
        self.assertFalse(graph.add_node(1))
        # Check it adds another node
        graph.add_node(2)
        self.assertEqual(graph.graph, {1: [], 2: []})

    def test_edges(self):
        # Going to add a directed edge from 1 to 2
        graph.add_edge(1, 2)
        self.assertEqual(graph.graph, {1: [2], 2: []})

    def test_multiple_nodes_and_edges(self):
        # Setting up DAG like diagram at top of file
        graph.add_node(3)
        graph.add_edge(1, 3)
        graph.add_node(4)
        graph.add_node(5)
        graph.add_edge(2, 4)
        graph.add_edge(2, 5)
        graph.add_node(6)
        graph.add_node(7)
        graph.add_edge(3, 6)
        graph.add_edge(3, 7)
        graph.add_node(8)
        graph.add_node(9)
        graph.add_node(10)
        graph.add_edge(5, 8)
        graph.add_edge(5, 9)
        graph.add_edge(5, 10)
        graph.add_node(11)
        graph.add_edge(6, 11)
        graph.add_edge(7, 11)
        self.assertEqual(graph.graph, {1: [2, 3], 2: [4, 5], 3: [6, 7], 4: [], 5: [8, 9, 10],
                                       6: [11], 7: [11], 8: [], 9: [], 10: [], 11: []})

    def test_lca(self):
        print(graph.dfs_wrapper(graph.graph, 1, 1))
        pass

    print("Success.")


if __name__ == '__main__':
    unittest.main()
