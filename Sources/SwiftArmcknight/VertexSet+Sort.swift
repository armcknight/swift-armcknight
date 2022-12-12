//
//  VertexSet+Sort.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 11/19/17.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

extension Set where Element == Vertex {

    func sortedLexicographically(increasing: Bool = true) -> [Vertex] {
        return self.sorted(by: { (a, b) -> Bool in
            if increasing {
                return b.lexicographicallyLargerThan(otherPoint: a)
            } else {
                return a.lexicographicallyLargerThan(otherPoint: b)
            }
        })
    }

    func sortedByX(increasing: Bool = true, increasingY: Bool = true) -> [Vertex] {
        let nonghosts = self.filter { !ghosts.contains($0) }
        return nonghosts.sorted { (a, b) -> Bool in
            if a.x == b.x {
                return increasingY ? a.y < b.y : a.y > b.y
            } else {
                return increasing ? a.x < b.x : a.x > b.x
            }
        }
    }

    func sortedByY(increasing: Bool = true, increasingX: Bool = true) -> [Vertex] {
        let nonghosts = self.filter { !ghosts.contains($0) }
        return nonghosts.sorted { (a, b) -> Bool in
            if a.y == b.y {
                return increasingX ? a.x < b.x : a.x > b.x
            } else {
                return increasing ? a.y < b.y : a.y > b.y
            }
        }
    }

}
