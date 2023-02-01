//
//  GraphTests.swift
//  
//
//  Created by Andrew McKnight on 12/16/22.
//

@testable import SwiftArmcknight
import XCTest

final class GraphTest: XCTestCase {
    private lazy var fixtures: Fixtures! = Fixtures()

    override func tearDown() {
        fixtures = nil
        super.tearDown()
    }

    // TODO: generate dynamic test cases per fixture, interpolating each fixture names into test case function names, instead of looping through fixtures in each test case

    func testOutboundEdgesFromAdjacencyList() {
        fixtures.all.forEach { name, fixture in
            for (node, edges) in fixture.adjacencyList {
                let computed = fixture.adjacencyListRepresentation.edges(leaving: node).hashValue
                let expected = edges.hashValue
                XCTAssertEqual(computed, expected)
            }
        }
    }

    func testOutboundEdgesFromAdjacencyMatrix() {
        fixtures.all.forEach { name, fixture in
            for (node, edges) in fixture.adjacencyList {
                let computed = fixture.adjacencyMatrixRepresentation.edges(leaving: node).hashValue
                let expected = edges.hashValue
                XCTAssertEqual(computed, expected)
            }
        }
    }

    func testAdjacencyListNodes() {
        fixtures.all.forEach { name, fixture in
            let expected = Set(fixture.nodes).hashValue
            let computed = fixture.adjacencyListRepresentation.nodes.hashValue
            XCTAssertEqual(computed, expected, "Nodes from adjacency list did not match input nodes for \(name)")
        }
    }

    func testAdjacencyListEdges() {
        fixtures.all.forEach { name, fixture in
            let expected = fixture.edges.hashValue
            let computed = fixture.adjacencyListRepresentation.edges.hashValue
            XCTAssertEqual(computed, expected, "Edges from adjacency list did not match input edge for \(name)")
        }
    }

    func testAdjacencyMatrixNodes() {
        fixtures.all.forEach { name, fixture in
            let expected = Set(fixture.nodes).hashValue
            let computed = fixture.adjacencyMatrixRepresentation.nodes.hashValue
            XCTAssertEqual(computed, expected, "Nodes from adjacency matrix did not match input nodes for \(name)")
        }
    }

    func testAdjacencyMatrixEdges() {
        fixtures.all.forEach { name, fixture in
            let expected = fixture.edges.hashValue
            let computed = fixture.adjacencyMatrixRepresentation.edges.hashValue
            XCTAssertEqual(computed, expected, "Edges from adjacency matrix did not match input edge for \(name)")
        }
    }

    func testConvertingFromAdjacencyMatrixToAdjacencyList() {
        fixtures.all.forEach { name, fixture in
            let expected = fixture.adjacencyListRepresentation.adjacencyList
            let computed = fixture.adjacencyMatrixRepresentation.adjacencyList
            XCTAssertEqual(computed.hashValue, expected.hashValue, "Transformed adjacency list did not match expected value for \(name)")
        }
    }

    func testConvertingFromAdjacencyListToAdjacencyMatrix() {
        fixtures.all.forEach { name, fixture in
            let expected = fixture.adjacencyMatrixRepresentation.adjacencyMatrix
            let computed = fixture.adjacencyListRepresentation.adjacencyMatrix
            XCTAssertEqual(computed.hashValue, expected.hashValue, "Transformed adjacency matsrix did not match expected value for \(name)")
        }
    }

    func testDescription() {
        fixtures.all.forEach {
            XCTAssertEqual(trimLines($0.1.adjacencyListRepresentation.description), trimLines($0.1.expectedDescription))
        }
    }

    func testGraphVizDotDescription() {
        fixtures.all.forEach {
            print($0.1.adjacencyListRepresentation.graphVizDotDescription)
            print("---")
        }
    }

    func testBreadthFirstSearch() {

    }

    func testDepthFirstSearch() {

    }

    func testMinimalSpanningForest() {

    }

    func testSingleSourceShortestPath() {

    }

    func testAllPairsShortestPaths() {

    }

    func testStronglyConnectedComponents() {

    }

    func testTopologicalSort() {

    }
}

private extension GraphTest {
    func trimLines(_ string: String) -> String {
        string.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces)}.joined(separator: "\n")
    }
}

private extension GraphTest {
    struct Fixtures {
        struct Fixture<E: EdgeProtocol> {
            var adjacencyListRepresentation: Graph<E>
            var adjacencyMatrixRepresentation: Graph<E>
            var adjacencyMatrix: [[Double?]]
            var adjacencyList: [E.NodeType: Set<E>]
            var nodes: Set<E.NodeType>
            var edges: Set<E>

            var expectedBreadthFirstSearchResults: [E.NodeType]
            var expectedDepthFirstSearchResults: [E.NodeType]
            var expectedSingleSourceShortestPathResults: [E.NodeType]
            var expectedMinimalSpanningForest: Set<Graph<E>>
            var expectedStronglyConnectedComponentsResult: Set<Graph<E>>
            var expectedAllPairsShortestPathsResult: Set<[E.NodeType]>
            var expectedTopologicalSortResult: [E.NodeType]
            var expectedGraphVizDescription: String
            var expectedDescription: String
        }

        lazy var all = [
            ("fullyConnectedGraph", fullyConnectedGraph),
            ("degenerateGraph", degenerateGraph),
            ("fullyDisconnectedGraph", fullyDisconnectedGraph),
            ("partiallyConnectedGraph", partiallyConnectedGraph),
        ]

        typealias FixtureGraphType = DirectedEdge<Node<String>, Double>

        // TODO: add test case for Int edge weights instead of Double. Will need different Djikstra starting values analogous to Double.infinity, maybe Int.max? or make it optional, or add a boolean flag for whether it's been computed or not

        /**
         * A fully connected graph.
         *
         * - Description:
         * ```
         *                 +---+
         *         +-----> | a | <+
         *         |       +---+  |
         *         |r        |    |
         *         |         |x   |u
         *         |         v    |
         *       +---+  y  +---+  |
         *    +- | c | <-- | b | <+----+
         *    |  +---+     +---+  |    |
         *    |    |         |    |    |
         *    |    |v        |z   |    |
         *    |    v         v    |    |t
         *    |  +---+  w  +---+  |    |
         *    |  | e | --> | d | -+    |
         *    |  +---+     +---+       |
         *    |    |         ^         |
         *    |    +---------+---------+
         *    |              |
         *    |              |s
         *    +--------------+
         * ```
         */
        private lazy var fullyConnectedGraph: Fixture<FixtureGraphType> = {
            let a = Node(value: "a", index: 0, initialDjikstraWeight: Double.infinity)
            let b = Node(value: "b", index: 1, initialDjikstraWeight: Double.infinity)
            let c = Node(value: "c", index: 2, initialDjikstraWeight: Double.infinity)
            let d = Node(value: "d", index: 3, initialDjikstraWeight: Double.infinity)
            let e = Node(value: "e", index: 4, initialDjikstraWeight: Double.infinity)

            let nodes = [a, b, c, d, e]

            let weight_R_CA = 1.64
            let weight_S_CD = 5.5
            let weight_T_EB = 6.532
            let weight_U_DA = 7.623
            let weight_V_CE = 8.25
            let weight_W_ED = 9.6721
            let weight_X_AB = 3.715
            let weight_Y_BC = 4.53
            let weight_Z_BD = 16.234

            let r = DirectedEdge(a: c, b: a, weight: weight_R_CA)
            let s = DirectedEdge(a: c, b: d, weight: weight_S_CD)
            let t = DirectedEdge(a: e, b: b, weight: weight_T_EB)
            let u = DirectedEdge(a: d, b: a, weight: weight_U_DA)
            let v = DirectedEdge(a: c, b: e, weight: weight_V_CE)
            let w = DirectedEdge(a: e, b: d, weight: weight_W_ED)
            let x = DirectedEdge(a: a, b: b, weight: weight_X_AB)
            let y = DirectedEdge(a: b, b: c, weight: weight_Y_BC)
            let z = DirectedEdge(a: b, b: d, weight: weight_Z_BD)

            let adjacencyMatrix = [
                [nil, weight_X_AB, nil, nil, nil],
                [nil, nil, weight_Y_BC, weight_Z_BD, nil],
                [weight_R_CA, nil, nil, weight_S_CD, weight_V_CE],
                [weight_U_DA, nil, nil, nil, nil],
                [nil, weight_T_EB, nil, weight_W_ED, nil],
            ]

            let edges = [r, s, t, u, v, w, x, y, z]

            let adjacencyList = [
                a: Set(arrayLiteral: x),
                b: Set(arrayLiteral: y, z),
                c: Set(arrayLiteral: s, v, r),
                d: Set(arrayLiteral: u),
                e: Set(arrayLiteral: t, w)
            ]

            return Fixture<FixtureGraphType>(
                adjacencyListRepresentation: Graph(adjacencyList: adjacencyList, initialFloydWarshallValue: Double.infinity),
                adjacencyMatrixRepresentation: Graph<FixtureGraphType>(adjacencyMatrix: adjacencyMatrix, nodes: nodes, initialFloydWarshallValue: Double.infinity),
                adjacencyMatrix: adjacencyMatrix,
                adjacencyList: adjacencyList,
                nodes: Set(nodes),
                edges: Set(edges),
                expectedBreadthFirstSearchResults: [],
                expectedDepthFirstSearchResults: [],
                expectedSingleSourceShortestPathResults: [],
                expectedMinimalSpanningForest: Set<Graph<FixtureGraphType>>(),
                expectedStronglyConnectedComponentsResult: Set<Graph<FixtureGraphType>>(),
                expectedAllPairsShortestPathsResult: Set<[FixtureGraphType.NodeType]>(),
                expectedTopologicalSortResult: [],
                expectedGraphVizDescription: "",
                expectedDescription: """
 ⦳   3.7   ⦳   ⦳   ⦳
 ⦳   ⦳   4.5   16.2   ⦳
 1.6   ⦳   ⦳   5.5   8.2
 7.6   ⦳   ⦳   ⦳   ⦳
 ⦳   6.5   ⦳   9.7   ⦳
"""
            )
        }()

        /**
         * A graph with no edges or nodes.
         */
        private lazy var degenerateGraph: Fixture<FixtureGraphType> = {
            let nodes = [Node<String>]()
            let adjacencyMatrix = [[Double?]]()
            let edges = [FixtureGraphType]()
            let adjacencyList = [Node<String> : Set<FixtureGraphType>]()

            return Fixture<FixtureGraphType>(
                adjacencyListRepresentation: Graph(adjacencyList: adjacencyList, initialFloydWarshallValue: Double.infinity),
                adjacencyMatrixRepresentation: Graph<FixtureGraphType>(adjacencyMatrix: adjacencyMatrix, nodes: nodes, initialFloydWarshallValue: Double.infinity),
                adjacencyMatrix: adjacencyMatrix,
                adjacencyList: adjacencyList,
                nodes: Set(nodes),
                edges: Set(edges),
                expectedBreadthFirstSearchResults: [],
                expectedDepthFirstSearchResults: [],
                expectedSingleSourceShortestPathResults: [],
                expectedMinimalSpanningForest: Set<Graph<FixtureGraphType>>(),
                expectedStronglyConnectedComponentsResult: Set<Graph<FixtureGraphType>>(),
                expectedAllPairsShortestPathsResult: Set<[FixtureGraphType.NodeType]>(),
                expectedTopologicalSortResult: [],
                expectedGraphVizDescription: "",
                expectedDescription: "∅"
            )
        }()

        /**
         * A graph with nodes but no edges.
         */
        private lazy var fullyDisconnectedGraph: Fixture<FixtureGraphType> = {
            let a = Node(value: "a", index: 0, initialDjikstraWeight: Double.infinity)
            let b = Node(value: "b", index: 1, initialDjikstraWeight: Double.infinity)
            let c = Node(value: "c", index: 2, initialDjikstraWeight: Double.infinity)
            let d = Node(value: "d", index: 3, initialDjikstraWeight: Double.infinity)
            let e = Node(value: "e", index: 4, initialDjikstraWeight: Double.infinity)
            let nodes = [a, b, c, d, e]
            let adjacencyMatrix: [[Double?]] = Array(repeating: Array(repeating: nil, count: nodes.count), count: nodes.count)
            let edges = [FixtureGraphType]()
            let adjacencyList: [Node<String> : Set<FixtureGraphType>] = [
                a: Set(),
                b: Set(),
                c: Set(),
                d: Set(),
                e: Set(),
            ]

            return Fixture<FixtureGraphType>(
                adjacencyListRepresentation: Graph(adjacencyList: adjacencyList, initialFloydWarshallValue: Double.infinity),
                adjacencyMatrixRepresentation: Graph<FixtureGraphType>(adjacencyMatrix: adjacencyMatrix, nodes: nodes, initialFloydWarshallValue: Double.infinity),
                adjacencyMatrix: adjacencyMatrix,
                adjacencyList: adjacencyList,
                nodes: Set(nodes),
                edges: Set(edges),
                expectedBreadthFirstSearchResults: [],
                expectedDepthFirstSearchResults: [],
                expectedSingleSourceShortestPathResults: [],
                expectedMinimalSpanningForest: Set<Graph<FixtureGraphType>>(),
                expectedStronglyConnectedComponentsResult: Set<Graph<FixtureGraphType>>(),
                expectedAllPairsShortestPathsResult: Set<[FixtureGraphType.NodeType]>(),
                expectedTopologicalSortResult: [],
                expectedGraphVizDescription: "",
                expectedDescription: """
 ⦳   ⦳   ⦳   ⦳   ⦳
 ⦳   ⦳   ⦳   ⦳   ⦳
 ⦳   ⦳   ⦳   ⦳   ⦳
 ⦳   ⦳   ⦳   ⦳   ⦳
 ⦳   ⦳   ⦳   ⦳   ⦳
"""
            )
        }()

        /**
         * A graph with multiple connected subgraphs.
         */
        private lazy var partiallyConnectedGraph: Fixture<FixtureGraphType> = {
            let a = Node(value: "a", index: 0, initialDjikstraWeight: Double.infinity)
            let b = Node(value: "b", index: 1, initialDjikstraWeight: Double.infinity)
            let c = Node(value: "c", index: 2, initialDjikstraWeight: Double.infinity)
            let d = Node(value: "d", index: 3, initialDjikstraWeight: Double.infinity)
            let e = Node(value: "e", index: 4, initialDjikstraWeight: Double.infinity)

            let nodes = [a, b, c, d, e]

            let weight_R_AB = 1.64
            let weight_S_BC = 5.5
            let weight_T_CA = 6.532

            let weight_U_DE = 7.623
            let weight_V_ED = 8.25

            let r = DirectedEdge(a: a, b: b, weight: weight_R_AB)
            let s = DirectedEdge(a: b, b: c, weight: weight_S_BC)
            let t = DirectedEdge(a: c, b: a, weight: weight_T_CA)

            let u = DirectedEdge(a: d, b: e, weight: weight_U_DE)
            let v = DirectedEdge(a: e, b: d, weight: weight_V_ED)

            let edges = [r, s, t, u, v]

            let adjacencyMatrix = [
                [nil, weight_R_AB, nil, nil, nil],
                [nil, nil, weight_S_BC, nil, nil],
                [weight_T_CA, nil, nil, nil, nil],
                [nil, nil, nil, nil, weight_U_DE],
                [nil, nil, nil, weight_V_ED, nil],
            ]

            let adjacencyList: [Node<String> : Set<FixtureGraphType>] = [
                a: Set(arrayLiteral: r),
                b: Set(arrayLiteral: s),
                c: Set(arrayLiteral: t),
                d: Set(arrayLiteral: u),
                e: Set(arrayLiteral: v),
            ]

            return Fixture<FixtureGraphType>(
                adjacencyListRepresentation: Graph(adjacencyList: adjacencyList, initialFloydWarshallValue: Double.infinity),
                adjacencyMatrixRepresentation: Graph<FixtureGraphType>(adjacencyMatrix: adjacencyMatrix, nodes: nodes, initialFloydWarshallValue: Double.infinity),
                adjacencyMatrix: adjacencyMatrix,
                adjacencyList: adjacencyList,
                nodes: Set(nodes),
                edges: Set(edges),
                expectedBreadthFirstSearchResults: [],
                expectedDepthFirstSearchResults: [],
                expectedSingleSourceShortestPathResults: [],
                expectedMinimalSpanningForest: Set<Graph<FixtureGraphType>>(),
                expectedStronglyConnectedComponentsResult: Set<Graph<FixtureGraphType>>(),
                expectedAllPairsShortestPathsResult: Set<[FixtureGraphType.NodeType]>(),
                expectedTopologicalSortResult: [],
                expectedGraphVizDescription: "",
                expectedDescription: """
 ⦳   1.6   ⦳   ⦳   ⦳
 ⦳   ⦳   5.5   ⦳   ⦳
 6.5   ⦳   ⦳   ⦳   ⦳
 ⦳   ⦳   ⦳   ⦳   7.6
 ⦳   ⦳   ⦳   8.2   ⦳
"""
            )
        }()
    }

}
