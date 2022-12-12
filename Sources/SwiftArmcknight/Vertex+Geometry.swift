//
//  Vertex+Geometry.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 9/11/18.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

extension Vertex {
    
    /**
     `ghost2` > all points > `ghost1`
     */
    func lexicographicallyLargerThan(otherPoint: Vertex) -> Bool {
        if self == ghost2 { return true }
        if otherPoint == ghost1 { return true }
        
        let result = self.y != otherPoint.y ? self.y > otherPoint.y : self.x > otherPoint.x
        return result
    }
    
}
