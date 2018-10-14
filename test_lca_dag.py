import unittest
from DAG import DAG

graph = DAG()


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

    print("Success.")


if __name__ == '__main__':
    unittest.main()
