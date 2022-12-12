//
//  Graph.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 12/18/21.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

public protocol NodeProtocol: Hashable {
    associatedtype ValueType: Hashable & CustomStringConvertible
    var value: ValueType { get set }
    var index: Int { get set }
    init(value: ValueType, index: Int)
}

public protocol EdgeProtocol: Hashable {
    associatedtype WeightType: CustomStringConvertible & Comparable
    associatedtype NodeType: NodeProtocol
    var weight: WeightType { get set }
    var a: NodeType { get set }
    var b: NodeType { get set }
    init(a: NodeType, b: NodeType, weight: WeightType)
}

public protocol GraphProtocol: CustomStringConvertible {
    associatedtype EdgeProtocolType: EdgeProtocol

    init(adjacencyMatrix: [[EdgeProtocolType.WeightType]], nodes: [EdgeProtocolType.NodeType])
    init(adjacencyList: [EdgeProtocolType.NodeType: [EdgeProtocolType]])

    var nodes: [EdgeProtocolType.NodeType] { get }
    var edges: [EdgeProtocolType] { get }

    /// - Complexity: possibly O(n^2) because of the resizing of the adjacency matrices.
    mutating func addNode(value: EdgeProtocolType.NodeType.ValueType)

    mutating func addDirectedEdge(_ from: EdgeProtocolType.NodeType, to: EdgeProtocolType.NodeType, withWeight weight: EdgeProtocolType.WeightType)
    mutating func addUndirectedEdge(_ vertices: (EdgeProtocolType.NodeType, EdgeProtocolType.NodeType), withWeight weight: EdgeProtocolType.WeightType)
    func weight(from: EdgeProtocolType.NodeType, to: EdgeProtocolType.NodeType) -> EdgeProtocolType.WeightType?

    func edges(leaving: EdgeProtocolType.NodeType) -> [EdgeProtocolType]
}

public struct Node<ValueType: Hashable & CustomStringConvertible>: NodeProtocol {
    public var value: ValueType
    public var index: Int

    public init(value: ValueType, index: Int) {
        self.value = value
        self.index = index
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

public struct DirectedEdge<NodeType: NodeProtocol, WeightType: CustomStringConvertible & BinaryInteger>: EdgeProtocol {
    public var weight: WeightType
    public var a: NodeType
    public var b: NodeType

    public init(a: NodeType, b: NodeType, weight: WeightType) {
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

public struct AdjacencyMatrixGraph<EdgeType: EdgeProtocol>: GraphProtocol {
    public typealias EdgeProtocolType = EdgeType

    var adjacencyMatrix: [[EdgeType.WeightType?]] = []

    public var nodes: [EdgeType.NodeType]
    public var edges: [EdgeType] {
        var _edges = [EdgeType]()
        for row in 0 ..< adjacencyMatrix.count {
            for column in 0 ..< adjacencyMatrix.count {
                if let weight = adjacencyMatrix[row][column] {
                    let a = nodes[row]
                    let b = nodes[column]
                    let edge: EdgeType = .init(a: a, b: b, weight: weight)
                    _edges.append(edge)
                }
            }
        }
        return _edges
    }

    public init(adjacencyMatrix: [[EdgeType.WeightType]], nodes: [EdgeType.NodeType]) {
        self.adjacencyMatrix = adjacencyMatrix
        self.nodes = nodes
    }

    public init(adjacencyList: [EdgeType.NodeType : [EdgeType]]) {
        nodes = adjacencyList.map { $0.key }
        self.adjacencyMatrix = .init(repeating: .init(repeating: nil, count: adjacencyList.count), count: adjacencyList.count)
        adjacencyList.forEach { nodeToEdges in
            nodeToEdges.value.forEach { edge in
                let weight = edge.weight
                adjacencyMatrix[edge.a.index][edge.b.index] = weight
            }
        }

    }

    public func weight(from: EdgeType.NodeType, to: EdgeType.NodeType) -> EdgeType.WeightType? {
        adjacencyMatrix[from.index][to.index]
    }

    // Adds a new vertex to the matrix.
    // Performance: possibly O(n^2) because of the resizing of the matrix.
    mutating public func addNode(value: EdgeType.NodeType.ValueType) {
        if nodes.contains(where: { $0.value == value }) {
            return
        }

        // Expand each existing row to the right one column.
        for i in 0 ..< adjacencyMatrix.count {
            adjacencyMatrix[i].append(nil)
        }

        // Add one new row at the bottom.
        let newRow = [EdgeType.WeightType?](repeating: nil, count: adjacencyMatrix.count + 1)
        adjacencyMatrix.append(newRow)

        let node: EdgeType.NodeType = .init(value: value, index: nodes.count)
        nodes.append(node)
    }

    mutating public func addDirectedEdge(_ from: EdgeType.NodeType, to: EdgeType.NodeType, withWeight weight: EdgeType.WeightType) {
        adjacencyMatrix[from.index][to.index] = weight
    }

    mutating public func addUndirectedEdge(_ vertices: (EdgeType.NodeType, EdgeType.NodeType), withWeight weight: EdgeType.WeightType) {
        addDirectedEdge(vertices.0, to: vertices.1, withWeight: weight)
        addDirectedEdge(vertices.1, to: vertices.0, withWeight: weight)
    }

    func weightFrom(_ sourceVertex: EdgeType.NodeType, to destinationVertex: EdgeType.NodeType) -> EdgeType.WeightType? {
        return adjacencyMatrix[sourceVertex.index][destinationVertex.index]
    }

    public func edges(leaving: EdgeType.NodeType) -> [EdgeType] {
        var outEdges = [EdgeType]()
        let fromIndex = leaving.index
        for column in 0..<adjacencyMatrix.count {
            if let weight = adjacencyMatrix[fromIndex][column] {
                let b = nodes[column]
                let edge: EdgeType = .init(a: leaving, b: b, weight: weight)
                outEdges.append(edge)
            }
        }
        return outEdges
    }

    public var description: String {
        var grid = [String]()
        let n = self.adjacencyMatrix.count
        for i in 0..<n {
            var row = ""
            for j in 0..<n {
                if let value = self.adjacencyMatrix[i][j] {
                    let number = NSString(format: "%.1f", value.description)
                    row += "\(value >= (0 as! EdgeType.WeightType) ? " " : "")\(number) "
                } else {
                    row += "  ø  "
                }
            }
            grid.append(row)
        }
        return (grid as NSArray).componentsJoined(by: "\n")
    }

}

