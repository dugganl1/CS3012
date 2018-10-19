import unittest
from DAG import DAG

"""
For testing purposes I'm going to contruct the following DAG (direction down). This will be used in the later tests.
Avoids having to keep creating new graph in each method.
          1
       /    \
      2      3
     / \     /\
    4   5   6  7
       /|\ /  \
      8 9 10  11
"""
global graph
graph = DAG()

for x in range(1, 12):
    graph.add_node(x)

graph.add_edge(1, 2)
graph.add_edge(1, 3)
graph.add_edge(2, 4)
graph.add_edge(2, 5)
graph.add_edge(3, 6)
graph.add_edge(3, 7)
graph.add_edge(5, 8)
graph.add_edge(5, 9)
graph.add_edge(5, 10)
graph.add_edge(6, 10)
graph.add_edge(6, 11)


class testLCA_DAG(unittest.TestCase):
    def setUp(self):
        pass

    def test_simple_adding_nodes_and_edges(self):
        # Check it adds a node
        basic_graph = DAG()
        basic_graph.add_node('A')
        self.assertEqual(basic_graph.graph, {'A': []})
        # Check it doesn't add a node if it already exists
        self.assertFalse(basic_graph.add_node('A'))
        # Check it adds another node
        basic_graph.add_node('B')
        self.assertEqual(basic_graph.graph, {'A': [], 'B': []})
        # Adding a directed edge from 1 to 2
        basic_graph.add_edge('A', 'B')
        self.assertEqual(basic_graph.graph, {'A': ['B'], 'B': []})
        # When adding an edge, if you include a node that isn't part of the graph it should trigger a ValueError
        self.assertRaises(ValueError, basic_graph.add_edge, 'B', 'C')

    def test_graph_setup(self):
        self.assertEqual(graph.graph, {1: [2, 3], 2: [4, 5], 3: [6, 7], 4: [], 5: [8, 9, 10], 6: [10, 11], 7: [], 8: [], 9: [], 10: [], 11: []})

        # Check that node that already exists wont be added again - i.e. should return false
        self.assertFalse(graph.add_node(10))

    def test_lca(self):
        # Check that the when the same node is passed in twice, it returns itself as the LCA
        self.assertEqual(graph.dfs_wrapper(graph.graph, 1, 1), 1)
        self.assertEqual(graph.dfs_wrapper(graph.graph, 6, 6), 6)

        # Now lets check some standard LCA's
        self.assertEqual(graph.dfs_wrapper(graph.graph, 8, 9), 5)
        self.assertEqual(graph.dfs_wrapper(graph.graph, 7, 4), 1)
        self.assertEqual(graph.dfs_wrapper(graph.graph, 7, 11), 3)

        # Test that if you include nodes that aren't in the graph, the LCA function returns None.
        # One node exists, one doesn't
        self.assertEqual(graph.dfs_wrapper(graph.graph, 10, 12), None)
        # Neither exists
        self.assertEqual(graph.dfs_wrapper(graph.graph, 15, 16), None)
        # Add rogue node with no edge to anything, there shouldn't be a LCA to our main graph
        graph.add_node(20)
        self.assertEqual(graph.dfs_wrapper(graph.graph, 1, 20), None)


if __name__ == '__main__':
    unittest.main()
