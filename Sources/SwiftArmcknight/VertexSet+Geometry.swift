//
//  VertexSet+Geometry.swift
//  Delaunay
//
//  Created by Andrew McKnight on 11/19/17.
//  Copyright © 2017 old dominion university. All rights reserved.
//

import Foundation

extension Set where Element == Vertex {

    func centerPoint() -> Vertex {
        let nonghosts = Set(self.filter { !ghosts.contains($0) })
        let sortedX = nonghosts.sortedByX()
        let sortedY = nonghosts.sortedByY()
        let centerX = (sortedX.last!.x - sortedX.first!.x) / 2.0
        let centerY = (sortedY.last!.y - sortedY.first!.y) / 2.0
        return Vertex(x: centerX, y: centerY, name: "CenterPoint(\(String(describing: self))")
    }

}
