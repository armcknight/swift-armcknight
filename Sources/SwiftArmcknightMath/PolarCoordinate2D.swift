//
//  PolarCoordinate2D.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 3/4/17.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

public struct PolarCoordinate2D {
    public let r: Double
    public let theta: Angle
    public let orientation: AngleOrientation

    public init(r: Double, theta: Angle, orientation: AngleOrientation = .counterclockwise) {
        self.r = r
        self.theta = theta
        self.orientation = orientation
    }

    public func cartesian() -> CartesianCoordinate2D {
        let counterclockwiseTheta = orientation == .counterclockwise ? theta.radians : 2 * .pi - theta.radians
        return CartesianCoordinate2D(x: r * cos(counterclockwiseTheta), y: r * sin(counterclockwiseTheta))
    }
}
