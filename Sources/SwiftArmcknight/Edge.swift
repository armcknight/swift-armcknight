//
//  Edge.swift
//  Delaunay
//
//  Created by Andrew McKnight on 11/8/17.
//  Copyright © 2017 old dominion university. All rights reserved.
//

import Foundation

public class Edge {

    public var a, b: Vertex
    
    /// Override value, if one was provided in `init(x:y:name:)`.
    /// - Seealso: `name`.
    private var _name: String?
    
    /// Used to generate a name for each instance created with `init(x:y:)` with no name override.
    /// - Seealso: `name`.
    private static var id: Int = 0
    
    /// Either the overriden value provided in `_name` if one exists, or the `String` representation of `id`.
    /// - Postcondition: `id` is incremented by 1 if `_name` is `nil`.
    /// - Seealso: `_name` and `id`.
    public lazy var name: String = {
        guard let nameOverride = _name else {
            let nextID = Edge.id
            Edge.id += 1
            let nextName = String(describing: nextID)
            self._name = nextName
            return nextName
        }
        return nameOverride
    }()

    init(x: Vertex, y: Vertex, name: String? = nil) {
        self._name = name
        self.a = x
        self.b = y
    }
}

public extension Edge {
    
    func briefDescription() -> String {
        return String(format: "E[%@, %@]", a.briefDescription(), b.briefDescription())
    }

    func containsGhostPoint() -> Bool {
        return endpoints().intersection(ghosts).count > 0
    }
    
    func isGhostEdge() -> Bool {
        return endpoints() == ghosts
    }

    func endpoints() -> Set<Vertex> {
        return Set<Vertex>([a, b])
    }
    
}

extension Edge: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(a)
        hasher.combine(b)
    }

}

extension Edge: CustomStringConvertible {

    public var description: String {
        return briefDescription()
    }

}

extension Edge: CustomDebugStringConvertible {
    public var debugDescription: String {
        return String(format: "Edge “%@”: [%@ %@]", name, String(reflecting: a), String(reflecting: b))
    }
}

public func ==(lhs: Edge, rhs: Edge) -> Bool {
    return lhs.a == rhs.a && lhs.b == rhs.b || lhs.a == rhs.b && lhs.b == rhs.a
}
