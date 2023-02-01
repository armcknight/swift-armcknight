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

    public init(adjacencyMatrix: [[EdgeType.Weight?]], nodes: [EdgeType.NodeType]) {
        // We want a typed, ordered collection of unique nodes. Since there is no swift generic ordered set, we ensure that there are no duplicate nodes using a precondition.
        precondition(nodes.count == Set(nodes).count)

        self.initializedWithList = false
        self.adjacencyMatrix = adjacencyMatrix
        self.nodes = nodes
    }

    public init(adjacencyList: [EdgeType.NodeType : Set<EdgeType>]) {
        self.initializedWithList = true
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
    func shortestPath(from node: inout EdgeType.NodeType, to end: EdgeType.NodeType) -> [EdgeType.NodeType] {
        if hasNegativeEdgeWeights {
            // TODO: bellman-ford
        } else {
            return djikstra(from: &node, to: end)
        }
        return []
    }

    /// - Returns: the collection of shortest paths from each node to every other node, if such a path exists between any given pair of nodes.
    func allPairsShortestPaths() -> Set<[EdgeType.NodeType]> {
        return [] // TODO: implement
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
