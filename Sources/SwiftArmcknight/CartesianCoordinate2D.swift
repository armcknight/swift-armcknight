//
//  CartesianCoordinate2D.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 3/4/17.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

public struct CartesianCoordinate2D {

    public let x: Double
    public let y: Double

    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    init(x: CGFloat, y: CGFloat) {
        self.x = Double(x)
        self.y = Double(y)
    }

}

public extension CartesianCoordinate2D {

    func angle(to b: CartesianCoordinate2D) -> Angle {
        let xDist = x - b.x
        let yDist = y - b.y
        let angle = atan2(yDist, xDist) + .pi
        return Angle(radians: angle)
    }
    
}

// MARK: CGPoint conversions

extension CartesianCoordinate2D {

    public init(cgPoint: CGPoint, size: CGSize) {
        let x = cgPoint.x - size.width / 2
        let y = size.height / 2 - cgPoint.y
        self = CartesianCoordinate2D(x: x, y: y)
    }

    public func cgPoint(_ canvasSize: CGSize) -> CGPoint {
        let x = CGFloat(self.x) + canvasSize.width / 2
        let y = canvasSize.height / 2 - CGFloat(self.y)
        return CGPoint(x: x, y: y);
    }

}
