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
    init(value: Value, index: Int)
}

public typealias EdgeWeightType = CustomStringConvertible & Comparable & Hashable

public protocol EdgeProtocol: Hashable {
    associatedtype Weight: EdgeWeightType
    associatedtype NodeType: NodeProtocol
    var weight: Weight { get set }
    var a: NodeType { get set }
    var b: NodeType { get set }
    init(a: NodeType, b: NodeType, weight: Weight)
}

public struct Node<Value: NodeValueType>: NodeProtocol {
    public var value: Value
    public var index: Int

    public init(value: Value, index: Int) {
        self.value = value
        self.index = index
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

    /// - Returns: the path of minimum total edge weight from `start` to `end`.
    func shortestPath(from node: EdgeType.NodeType, to end: EdgeType.NodeType) -> [EdgeType.NodeType] {
        // TODO: implement; use djikstra or bellman-ford depending on whether there are negative edge weights
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

