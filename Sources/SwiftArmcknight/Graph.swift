//
//  Graph.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 12/18/21.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

public typealias NodeValueType = Hashable & CustomStringConvertible

public protocol NodeProtocol: Hashable {
    associatedtype Value: NodeValueType
    var value: Value { get set }
    var index: Int { get set }
    init(value: Value, index: Int, initialDjikstraWeight: any EdgeWeightType)

    var djikstraWeight: any EdgeWeightType { get set }
    var djikstraPath: [any NodeProtocol] { get set }
}

public typealias EdgeWeightType = CustomStringConvertible & Comparable & Hashable & AdditiveArithmetic

public protocol EdgeProtocol: Hashable {
    associatedtype Weight: EdgeWeightType
    associatedtype NodeType: NodeProtocol
    var weight: Weight { get set }
    var a: NodeType { get set }
    var b: NodeType { get set }
    init(a: NodeType, b: NodeType, weight: Weight)
}

public struct Node<Value: NodeValueType>: NodeProtocol {
    public static func == (lhs: Node<Value>, rhs: Node<Value>) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public var value: Value
    public var index: Int

    public var djikstraWeight: any EdgeWeightType
    public var djikstraPath: [any NodeProtocol] = []

    public init(value: Value, index: Int, initialDjikstraWeight: any EdgeWeightType) {
        self.value = value
        self.index = index
        self.djikstraWeight = initialDjikstraWeight
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

public struct DirectedEdge<NodeType: NodeProtocol, Weight: EdgeWeightType>: EdgeProtocol {
    public var weight: Weight
    public var a: NodeType
    public var b: NodeType

    public init(a: NodeType, b: NodeType, weight: Weight) {
        self.a = a
        self.b = b
        self.weight = weight
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(weight)
        hasher.combine(a)
        hasher.combine(b)
    }
}

public protocol GraphVizDotDescriptionConvertible {
    var graphVizDotDescription: String { get }
}

public protocol LosslessGraphVizDotDescriptionConvertible: GraphVizDotDescriptionConvertible {
    init?(graphVizDotDescription: String)
}

extension Graph: GraphVizDotDescriptionConvertible {
    public var graphVizDotDescription: String {
        return "" // TODO: implement
    }
}

extension Graph: CustomStringConvertible {
    private var emptyGraph: String { "∅" }
    private var noEdge: String { "⦳" }

    public var description: String {
        guard !adjacencyList.isEmpty else { return emptyGraph }
        return (adjacencyMatrix as [[(any Comparable)?]]).gridDescription {
            if let float = $0 as? any FloatingPoint {
                if $0 != nil {
                    let number = NSString(format: "%.1f", float as! CVarArg)
                    return "\($0 as! EdgeType.Weight >= (0.0 as! EdgeType.Weight) ? " " : "")\(number) "
                } else {
                    return "  \(self.noEdge)  "
                }
            } else {
                if $0 != nil {
                    let number = "\($0!)"
                    return "\($0 as! EdgeType.Weight >= (0 as! EdgeType.Weight) ? " " : "")\(number) "
                } else {
                    return " \(self.noEdge) "
                }
            }

        }
    }
}

// TODO: implement where UIKit is available to return a UIImage of a graphviz rendered image? might need a separate package specifically for this kind of thing that depends on this one since we don't want a UIKit dependency in this package
//extension Graph: CustomPlaygroundDisplayConvertible {
//    public var playgroundDescription: Any {
//        // TODO: implement
//    }
//}

extension Graph: Hashable {
    public static func == (lhs: Graph<EdgeType>, rhs: Graph<EdgeType>) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(nodes)
        hasher.combine(edges)
    }
}

public class Graph<EdgeType: EdgeProtocol>: LosslessGraphVizDotDescriptionConvertible {
    let initializedWithList: Bool

    public required init?(graphVizDotDescription: String) {
        return nil // TODO: implement
    }

    lazy var adjacencyMatrix: [[EdgeType.Weight?]] = {
        var adjacencyMatrix: [[EdgeType.Weight?]] = .init(repeating: .init(repeating: nil, count: adjacencyList.count), count: adjacencyList.count)
        adjacencyList.forEach { nodeToEdges in
            nodeToEdges.value.forEach { edge in
                let weight = edge.weight
                adjacencyMatrix[edge.a.index][edge.b.index] = weight
            }
        }
        return adjacencyMatrix
    }()

    lazy var adjacencyList: [EdgeType.NodeType : Set<EdgeType>] = {
        var _adjacencyList = [EdgeType.NodeType : Set<EdgeType>]()

        for row in 0 ..< self.adjacencyMatrix.count {
            for col in 0 ..< self.adjacencyMatrix.count {
                guard let weight = self.adjacencyMatrix[row][col] else { continue }
                let element = DirectedEdge(a: self.nodes[row], b: self.nodes[col], weight: weight)
                if _adjacencyList[self.nodes[row]] == nil {
                    _adjacencyList[self.nodes[row]] = Set(arrayLiteral: element as! EdgeType)
                } else {
                    _adjacencyList[self.nodes[row]]!.insert(element as! EdgeType)
                }
            }
        }

        nodes.forEach { node in
            if _adjacencyList[node] == nil {
                _adjacencyList[node] = Set()
            }
        }

        return _adjacencyList
    }()

    public lazy var nodes: [EdgeType.NodeType] = {
        if initializedWithList {
            return Array(adjacencyList.keys)
        } else {
            return [] // never actually taken; this property will be assigned from the initializer
        }
    }()

    public lazy var edges: Set<EdgeType> = {
        Set(adjacencyList.values.joined())
    }()

    public lazy var hasNegativeEdgeWeights: Bool = {
        edges.contains { edge in
            edge.weight < (0 as! EdgeType.Weight)
        }
    }()

    let shortestPathSentinelValue: EdgeType.Weight

    public init(adjacencyMatrix: [[EdgeType.Weight?]], nodes: [EdgeType.NodeType], shortestPathSentinelValue: EdgeType.Weight) {
        // We want a typed, ordered collection of unique nodes. Since there is no swift generic ordered set, we ensure that there are no duplicate nodes using a precondition.
        precondition(nodes.count == Set(nodes).count)

        self.initializedWithList = false
        self.shortestPathSentinelValue = shortestPathSentinelValue
        self.adjacencyMatrix = adjacencyMatrix
        self.nodes = nodes
    }

    public init(adjacencyList: [EdgeType.NodeType : Set<EdgeType>], shortestPathSentinelValue: EdgeType.Weight) {
        self.initializedWithList = true
        self.shortestPathSentinelValue = shortestPathSentinelValue
        self.adjacencyList = adjacencyList
    }

    public func weight(from: EdgeType.NodeType, to: EdgeType.NodeType) -> EdgeType.Weight? {
        adjacencyMatrix[from.index][to.index]
    }

    public func edges(leaving: EdgeType.NodeType) -> Set<EdgeType> {
        adjacencyList[leaving] ?? Set()
    }

    /// - Returns: the shortest path by number of edges from `start` to `end`.
    /// - Note: Used for finding the shortest path between two nodes, testing if a graph is bipartite, finding all connected components in a graph, etc.
    /// - Note: Optimal for finding the shortest distance vs `dfs`.
    func breadthFirstSearch(from start: EdgeType.NodeType, to end: EdgeType.NodeType) -> [EdgeType.NodeType] {
        // TODO: implement
        return []
    }

    /// - Returns: the shortest path by number of edges from `start` to `end`.
    /// - Note: Used for topological sorting, solving problems that require graph backtracking, detecting cycles in a graph, finding paths between two nodes, etc.
    func depthFirstSearch(from start: EdgeType.NodeType, to end: EdgeType.NodeType) -> [EdgeType.NodeType] {
        // TODO: implement
        return []
    }

    func minimalSpanningForest() -> Set<Graph> {
        // TODO: implement
        return []
    }

    /// - Returns: the path of minimum total edge weight from `start` to `end` as an ordered collection of nodes along the path.
    func shortestPath(from node: inout EdgeType.NodeType, to end: EdgeType.NodeType) -> [EdgeType.NodeType]? {
        if hasNegativeEdgeWeights {
            guard let result: BellmanFordResult<EdgeType.Weight> = bellmanFord(source: node) else {
                return nil
            }
            return result.path(to: end, nodes: nodes)
        } else {
            return djikstra(from: &node, to: end)
        }
    }

    /// Uses the Floyd-Warshall algorithm for computing all-pairs shortest paths in a weighted directed graph.
    /// - precondition: `graph` must have no negative weight cycles
    /// - complexity: `Θ(V^3)` time, `Θ(V^2)` space
    /// - note: In all complexity bounds, `V` is the number of vertices in the graph, and `E` is the number of edges.
    /// - Returns: the collection of shortest paths from each node to every other node, if such a path exists between any given pair of nodes.
    func allPairsShortestPaths<T>() -> FloydWarshallResult<T>? where T: EdgeWeightType {
        guard !hasNegativeEdgeWeights else {
            return nil
        }
        let result: FloydWarshallResult<T> = floydWarshall()
        return result
    }

    /// - Returns: the collection of strongly connected components.
    func stronglyConnectedComponents() -> Set<Graph> {
        return Set() // TODO: implement
    }

    func topologicalSort() -> [EdgeType.NodeType] {
        return [] // TODO: implement
    }
}

// Djikstra's algorithm logic to compute single-source shortest paths when no negative edge weights are present
private extension Graph {
    /// - note: The following logic in this scope and related code added with it is
    /// based on the implementation of Djikstra's algorithm from the Swift
    /// Algorithm Club, which requires the following license text to appear
    /// with it:
    /// ```
    /// Copyright (c) 2016 Matthijs Hollemans and contributors
    ///
    /// Permission is hereby granted, free of charge, to any person obtaining a copy
    /// of this software and associated documentation files (the "Software"), to deal
    /// in the Software without restriction, including without limitation the rights
    /// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    /// copies of the Software, and to permit persons to whom the Software is
    /// furnished to do so, subject to the following conditions:
    ///
    /// The above copyright notice and this permission notice shall be included in
    /// all copies or substantial portions of the Software.
    ///
    /// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    /// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    /// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    /// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    /// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    /// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    /// THE SOFTWARE.
    /// ```
    func djikstra(from node: inout EdgeType.NodeType, to end: EdgeType.NodeType) -> [EdgeType.NodeType] {
        let currentNodes = [EdgeType.NodeType]()
        node.djikstraWeight = 0
        node.djikstraPath.append(node)
        var currentNode: EdgeType.NodeType? = node
        while let node = currentNode {
            (currentNodes as! NSMutableArray).remove(node)
            let edges = edges(leaving: node).filter { currentNodes.contains($0.b) }
            for edge in edges {
                var neighborVertex = edge.b
                let weight = edge.weight

                let weightToNeighbor = neighborVertex.djikstraWeight as! EdgeType.Weight
                let theoreticNewWeight = node.djikstraWeight as! EdgeType.Weight + weight
                if theoreticNewWeight < weightToNeighbor {
                    neighborVertex.djikstraWeight = theoreticNewWeight
                    neighborVertex.djikstraPath = node.djikstraPath
                    neighborVertex.djikstraPath.append(neighborVertex)
                }
            }
            if currentNodes.isEmpty {
                currentNode = nil
                break
            }
            currentNode = currentNodes.min { ($0.djikstraWeight as! EdgeType.Weight) < ($1.djikstraWeight as! EdgeType.Weight) }
        }
        return currentNode?.djikstraPath as! [EdgeType.NodeType]
    }
}

// Floyd-Warshall logic to compute all-pairs shortest paths
extension Graph {
    /**
     `FloydWarshallResult` encapsulates the result of the computation, namely the
     minimized distance adjacency matrix, and the matrix of predecessor indices.

     It conforms to the `APSPResult` procotol which provides methods to retrieve
     distances and paths between given pairs of start and end nodes.
     */
    struct FloydWarshallResult<T> where T: Hashable {
        fileprivate var weights: Distances
        fileprivate var predecessors: Predecessors

        /// - complexity: `Θ(1)` time/space
        /// - Returns: the total weight of the path from a starting vertex to a destination. This value is the minimal connected weight between the two vertices, or `nil` if no path exists
        func distance(fromVertex from: EdgeType.NodeType, toVertex to: EdgeType.NodeType) -> EdgeType.Weight? {
            return weights[from.index][to.index]
        }

        /// - complexity: `Θ(V)` time, `Θ(V^2)` space
        /// - Returns: the reconstructed path from a starting vertex to a destination, as an ordered array, or `nil` if no path exists
        func path(fromVertex from: EdgeType.NodeType, toVertex to: EdgeType.NodeType, nodes: [EdgeType.NodeType]) -> [EdgeType.NodeType]? {
            return recursePathFrom(fromVertex: from, toVertex: to, path: [ to ], nodes: nodes)
        }

        /// The recursive component to rebuilding the shortest path between two vertices using the predecessor matrix.
        /// - Returns: the list of predecessors discovered so far
        func recursePathFrom(fromVertex from: EdgeType.NodeType, toVertex to: EdgeType.NodeType, path: [EdgeType.NodeType], nodes: [EdgeType.NodeType]) -> [EdgeType.NodeType]? {
            if from.index == to.index {
                return [ from, to ]
            }

            if let predecessor = predecessors[from.index][to.index] {
                let predecessorVertex = nodes[predecessor]
                if predecessor == from.index {
                    let newPath = [ from, to ]
                    return newPath
                } else {
                    let buildPath = recursePathFrom(fromVertex: from, toVertex: predecessorVertex, path: path, nodes: nodes)
                    let newPath = buildPath! + [ to ]
                    return newPath
                }
            }
            return nil
        }
    }
}

private extension Graph {
    typealias Distances = [[EdgeType.Weight]]
    typealias Predecessors = [[Int?]]
    typealias StepResult = (distances: Distances, predecessors: Predecessors)

    /// - complexity: `Θ(V^3)` time, `Θ(V^2)` space
    /// - returns: a `FloydWarshallResult` struct which can be queried for shortest paths and their total weights
    /// - note: The following logic in this scope and related code added with it is
    /// based on the implementation of Djikstra's algorithm from the Swift
    /// Algorithm Club, which requires the following license text to appear
    /// with it.  **However, also note that I was the contributor of this algorithm to the Swift Algorithm Club!**
    /// ```
    /// Copyright (c) 2016 Matthijs Hollemans and contributors
    ///
    /// Permission is hereby granted, free of charge, to any person obtaining a copy
    /// of this software and associated documentation files (the "Software"), to deal
    /// in the Software without restriction, including without limitation the rights
    /// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    /// copies of the Software, and to permit persons to whom the Software is
    /// furnished to do so, subject to the following conditions:
    ///
    /// The above copyright notice and this permission notice shall be included in
    /// all copies or substantial portions of the Software.
    ///
    /// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    /// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    /// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    /// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    /// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    /// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    /// THE SOFTWARE.
    /// ```
    func floydWarshall<T: EdgeWeightType>() -> FloydWarshallResult<T> {
        var previousDistance = constructInitialDistanceMatrix()
        var previousPredecessor = constructInitialPredecessorMatrix(previousDistance)
        for intermediateIdx in 0 ..< nodes.count {
            let nextResult = nextStep(intermediateIdx, previousDistances: previousDistance, previousPredecessors: previousPredecessor)
            previousDistance = nextResult.distances
            previousPredecessor = nextResult.predecessors

            //                // uncomment to see each new weight matrix
            //                print("  D(\(k)):\n")
            //                printMatrix(nextResult.distances)
            //
            //                // uncomment to see each new predecessor matrix
            //                print("  ∏(\(k)):\n")
            //                printIntMatrix(nextResult.predecessors)
        }
        return FloydWarshallResult<T>(weights: previousDistance, predecessors: previousPredecessor)
    }

    /// For each iteration of `intermediateIdx`, perform the comparison for the dynamic algorithm, checking for each pair of start/end vertices, whether a path taken through another vertex produces a shorter path.
    /// - complexity: `Θ(V^2)` time/space
    /// - returns: a tuple containing the next distance matrix with weights of currently known shortest paths and the corresponding predecessor matrix
    func nextStep(_ intermediateIdx: Int, previousDistances: Distances, previousPredecessors: Predecessors) -> StepResult {
        let vertexCount = nodes.count
        var nextDistances = Array(repeating: Array(repeating: shortestPathSentinelValue, count: vertexCount), count: vertexCount)
        var nextPredecessors = Array(repeating: Array<Int?>(repeating: nil, count: vertexCount), count: vertexCount)

        for fromIdx in 0 ..< vertexCount {
            for toIndex in 0 ..< vertexCount {
                //        printMatrix(previousDistances, i: fromIdx, j: toIdx, k: intermediateIdx) // uncomment to see each comparison being made
                let originalPathWeight = previousDistances[fromIdx][toIndex]
                let newPathWeightBefore = previousDistances[fromIdx][intermediateIdx]
                let newPathWeightAfter = previousDistances[intermediateIdx][toIndex]

                let minimum = min(originalPathWeight, newPathWeightBefore + newPathWeightAfter)
                nextDistances[fromIdx][toIndex] = minimum

                var predecessor: Int?
                if originalPathWeight <= newPathWeightBefore + newPathWeightAfter {
                    predecessor = previousPredecessors[fromIdx][toIndex]
                } else {
                    predecessor = previousPredecessors[intermediateIdx][toIndex]
                }
                nextPredecessors[fromIdx][toIndex] = predecessor
            }
        }
        return (nextDistances, nextPredecessors)
    }

    /**
     We need to map the graph's weight domain onto the one required by the algorithm: the graph
     stores either a weight as a `Double` or `nil` if no edge exists between two vertices, but
     the algorithm needs a lack of an edge represented as ∞ for the `min` comparison to work correctly.

     - complexity: `Θ(V^2)` time/space
     - returns: weighted adjacency matrix in form ready for processing with Floyd-Warshall
     */
    func constructInitialDistanceMatrix() -> Distances {
        var distances = Array(repeating: Array(repeating: shortestPathSentinelValue, count: nodes.count), count: nodes.count)

        for row in nodes {
            for col in nodes {
                let rowIdx = row.index
                let colIdx = col.index
                if rowIdx == colIdx {
                    distances[rowIdx][colIdx] = 0 as! EdgeType.Weight
                } else if let w = weight(from: row, to: col) {
                    distances[rowIdx][colIdx] = w
                }
            }
        }

        return distances
    }

    /**
     Make the initial predecessor index matrix. Initially each value is equal to it's row index, it's "from" index when querying into it.

     - complexity: `Θ(V^2)` time/space
     */
    func constructInitialPredecessorMatrix(_ distances: Distances) -> Predecessors {
        let vertexCount = distances.count
        var predecessors = Array(repeating: Array<Int?>(repeating: nil, count: vertexCount), count: vertexCount)

        for fromIdx in 0 ..< vertexCount {
            for toIdx in 0 ..< vertexCount {
                if fromIdx != toIdx && distances[fromIdx][toIdx] < shortestPathSentinelValue {
                    predecessors[fromIdx][toIdx] = fromIdx
                }
            }
        }

        return predecessors
    }
}

// Bellman-Ford algorithm logic to compute single-source shortest paths when negative edge weights are present
private extension Graph {
    /// Compute the shortest path from `source` to each other vertex in `graph`,
    /// if such paths exist. Also report negative weight cycles reachable from `source`,
    /// which are cycles whose sum of edge weights is negative.
    ///
    /// - precondition: `graph` must have no negative weight cycles
    /// - complexity: `O(VE)` time, `Θ(V)` space
    /// - returns a `BellmanFordResult` struct which can be queried for
    /// shortest paths and their total weights, or `nil` if a negative weight cycle exists
    /// - note: The following logic in this scope and related code added with it is
    /// based on the implementation of Djikstra's algorithm from the Swift
    /// Algorithm Club, which requires the following license text to appear
    /// with it. **However, also note that I was the contributor of this algorithm to the Swift Algorithm Club!**
    /// ```
    /// Copyright (c) 2016 Matthijs Hollemans and contributors
    ///
    /// Permission is hereby granted, free of charge, to any person obtaining a copy
    /// of this software and associated documentation files (the "Software"), to deal
    /// in the Software without restriction, including without limitation the rights
    /// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    /// copies of the Software, and to permit persons to whom the Software is
    /// furnished to do so, subject to the following conditions:
    ///
    /// The above copyright notice and this permission notice shall be included in
    /// all copies or substantial portions of the Software.
    ///
    /// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    /// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    /// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    /// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    /// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    /// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    /// THE SOFTWARE.
    /// ```
    func bellmanFord<T>(source: EdgeType.NodeType) -> BellmanFordResult<T>? where T: EdgeWeightType {
        var predecessors = Array<Int?>(repeating: nil, count: nodes.count)
        var weights = Array(repeating: shortestPathSentinelValue, count: nodes.count)
        predecessors[source.index] = source.index
        weights[source.index] = 0 as! EdgeType.Weight

        for _ in 0 ..< nodes.count - 1 {
            var weightsUpdated = false
            edges.forEach { edge in
                let weight = edge.weight
                let relaxedDistance = weights[edge.a.index] + weight
                let nextVertexIdx = edge.b.index
                if relaxedDistance < weights[nextVertexIdx] {
                    predecessors[nextVertexIdx] = edge.a.index
                    weights[nextVertexIdx] = relaxedDistance
                    weightsUpdated = true
                }
            }
            if !weightsUpdated {
                break
            }
        }

        // check for negative weight cycles reachable from the source vertex
        // TODO: modify to incorporate solution to 24.1-4, pg 654, to set the weight of a path containing a negative weight cycle to -∞, instead of returning nil for the entire result
        for edge in edges {
            if weights[edge.b.index] > weights[edge.a.index] + edge.weight {
                return nil
            }
        }

        return BellmanFordResult(predecessors: predecessors, weights: weights, shortestPathSentinelValue: shortestPathSentinelValue)
    }

    /**
     `BellmanFordResult` encapsulates the result of the computation,
     namely the minimized distances, and the predecessor indices.

     It conforms to the `SSSPResult` procotol which provides methods to
     retrieve distances and paths between given pairs of start and end nodes.
     */
    struct BellmanFordResult<T> where T: EdgeWeightType {
        var predecessors: [Int?]
        var weights: [EdgeType.Weight]
        var shortestPathSentinelValue: EdgeType.Weight

        /**
         - returns: the total weight of the path from the source vertex to a destination.
         This value is the minimal connected weight between the two vertices, or `nil` if no path exists
         - complexity: `Θ(1)` time/space
         */
        func distance(to: EdgeType.NodeType) -> EdgeType.Weight? {
            let distance = weights[to.index]

            guard distance != shortestPathSentinelValue else {
                return nil
            }

            return distance
        }

        /**
         - returns: the reconstructed path from the source vertex to a destination,
         as an array containing the data property of each vertex, or `nil` if no path exists
         - complexity: `Θ(V)` time, `Θ(V^2)` space
         */
        public func path(to: EdgeType.NodeType, nodes: [EdgeType.NodeType]) -> [EdgeType.NodeType]? {
            guard weights[to.index] != shortestPathSentinelValue else {
                return nil
            }

            return recursePath(to: to, path: [to], nodes: nodes)
        }

        /**
         The recursive component to rebuilding the shortest path between two vertices using predecessors.

         - returns: the list of predecessors discovered so far, or `nil` if the next vertex has no predecessor
         */
        fileprivate func recursePath(to: EdgeType.NodeType, path: [EdgeType.NodeType], nodes: [EdgeType.NodeType]) -> [EdgeType.NodeType]? {
            guard let predecessorIdx = predecessors[to.index] else {
                return nil
            }

            let predecessor = nodes[predecessorIdx]
            if predecessor.index == to.index {
                return [ to ]
            }

            guard let buildPath = recursePath(to: predecessor, path: path, nodes: nodes) else {
                return nil
            }

            return buildPath + [ to ]
        }
    }
}
