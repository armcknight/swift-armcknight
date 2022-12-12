//
//  Line2D.swift
// swift-armcknight
//
//  Created by Andrew McKnight on 4/25/22.
//

import Foundation

/// Calculate the slope of a line given two points on that line.
public func _slope(a: CGPoint, b: CGPoint) -> CGFloat {
    let xDiff = (b.x - a.x)
    guard xDiff != 0 else {
        return CGFloat.infinity
    }
    return (b.y - a.y) / xDiff
}

/// Given the slope of a line and a point on the line, calculate the Y value where the line intersects the Y axis.
public func _yIntercept(slope: CGFloat, point: CGPoint) -> CGFloat {
    guard slope != CGFloat.infinity else {
        return CGFloat.nan
    }
    return point.y - slope * point.x
}

/// Given the slope of a line and a point on the line, calculate the Y value where the line intersects the Y axis.
/// 0 = mx + b
/// -b = mx
/// -b/m = x
public func _xIntercept(slope: CGFloat, point: CGPoint) -> CGFloat {
    guard slope != 0 else {
        return CGFloat.nan
    }
    guard slope != CGFloat.infinity else {
        return point.x
    }
    return -_yIntercept(slope: slope, point: point) / slope
}

/// Calculate the point where this line intersects with another specified line, if they intersect at exactly one point. If they are parallel or colinear, return `nil`.
func _intersection(am: CGFloat, ab: CGFloat, bm: CGFloat, bb: CGFloat) -> CGPoint? {
    // y1 = y2
    // m1 * x + b1 = m2 * x + b2
    // m1 * x - m2 * x = b2 - b1
    // x(m1 - m2) = b2 - b1
    // x = (b2 - b1) / (m1 - m2) -> x coordinate
    let x = (bb - ab) / (am - bm)

    // y1 = m1 * x1 + b1 -> y coordinate after substituting the value of x found above
    let y = am * x + ab
    return CGPoint(x: x, y: y)
}

public struct Line2D: CustomStringConvertible, Equatable {
    public let slope: CGFloat
    public let yIntercept: CGFloat
    private var __xIntercept: CGFloat?

    public var xIntercept: CGFloat {
        return __xIntercept ?? _xIntercept(slope: slope, point: CGPoint(x: 0, y: yIntercept))
    }

    public var isVertical: Bool {
        return slope == CGFloat.infinity
    }

    public init(a: CGPoint, b: CGPoint) {
        self.slope = _slope(a: a, b: b)
        self.yIntercept = _yIntercept(slope: slope, point: b)
    }

    public init(slope: CGFloat, yIntercept: CGFloat) {
        self.slope = slope
        self.yIntercept = yIntercept
    }

    public init(verticalLineAtX x: CGFloat) {
        self.slope = CGFloat.infinity
        self.yIntercept = CGFloat.nan
        self.__xIntercept = x
    }

    public var description: String {
        String(format: "Line2D: slope (%f); yIntercept (%f)", slope, yIntercept)
    }

    static public func ==(lhs: Line2D, rhs: Line2D) -> Bool {
        return lhs.slope == rhs.slope && lhs.yIntercept == rhs.yIntercept
    }
}

public extension Line2D {
    /// Calculate the point where this line intersects with another specified line, if they intersect at exactly one point. If they are parallel or colinear, return `nil`.
    func intersects(line: Line2D) -> CGPoint? {
        guard self != line else {
            // TODO: log
            return nil
        }

        // if only one line is vertical, they're guaranteed to intersect. simply solve the other line for the vertical line's x-intercept
        if isVertical, let solvedY = line.solveFor(x: xIntercept) {
            return CGPoint(x: xIntercept, y: solvedY)
        } else if line.isVertical, let solvedY = solveFor(x: line.xIntercept) {
            return CGPoint(x: line.xIntercept, y: solvedY)
        }

        // y1 = y2
        // m1 * x + b1 = m2 * x + b2
        // m1 * x - m2 * x = b2 - b1
        // x(m1 - m2) = b2 - b1
        // x = (b2 - b1) / (m1 - m2) -> x coordinate
        let slopeDelta = (slope - line.slope)
        guard slopeDelta != 0 else {
            // TODO: log
            return nil
        }
        let x = (line.yIntercept - yIntercept) / slopeDelta

        // y1 = m1 * x1 + b1 -> y coordinate after substituting the value of x found above
        let y = line.slope * x + line.yIntercept
        return CGPoint(x: x, y: y)
    }

    func solveFor(x: CGFloat) -> CGFloat? {
        guard !isVertical else { return nil }
        return slope * x + yIntercept
    }
}

public struct LineSegment2D: CustomStringConvertible {
    public let slope: CGFloat
    public let yIntercept: CGFloat
    public let a: CGPoint
    public let b: CGPoint

    public init(a: CGPoint, b: CGPoint) {
        self.slope = _slope(a: a, b: b)
        self.yIntercept = _yIntercept(slope: slope, point: b)
        self.a = a
        self.b = b
    }

    public var midpoint: CGPoint {
        let x = (a.x + b.x) / 2.0
        let y = (a.y + b.y) / 2.0
        return CGPoint(x: x, y: y)
    }

    public var perpendicularBisector: Line2D {
        guard slope != 0 else { return Line2D(verticalLineAtX: midpoint.x) }
        let negativeReciprocal: CGFloat = -1.0 / slope

        // where y1 and x1 are the midpoint of this segment
        // y - y1 = m(x - x1)
        // y = m(x - x1) + y1
        // y = mx - mx1 + y1
        //          |------|
        //              V
        // y = mx +     b
        // b = y1 - m * x1
        return Line2D(slope: negativeReciprocal, yIntercept: midpoint.y - negativeReciprocal * midpoint.x)
    }

    public var description: String {
        String(format: "LineSegment2D: a (%@); b (%@); slope (%f); yIntercept (%f)", String(describing: a), String(describing: b), slope, yIntercept)
    }
}

public extension LineSegment2D {

    func solveFor(x: CGFloat) -> CGFloat {
        slope * x + yIntercept
    }

    /// Calculate the point where this line intersects with another specified line, if they intersect at exactly one point. If they are parallel or colinear, or do not intersect, return `nil`.
    func intersects(line: LineSegment2D) -> CGPoint? {
        // y1 = y2
        // m1 * x + b1 = m2 * x + b2
        // m1 * x - m2 * x = b2 - b1
        // x(m1 - m2) = b2 - b1
        // x = (b2 - b1) / (m1 - m2) -> x coordinate
        let slopeDelta = (slope - line.slope)
        guard slopeDelta != 0 else { return nil }
        let x = (line.yIntercept - yIntercept) / slopeDelta

        // y1 = m1 * x1 + b1 -> y coordinate after substituting the value of x found above
        let y = slope * x + yIntercept

        let point = CGPoint(x: x, y: y)

        // make sure the point lies between the endpoints of both segments, otherwise the segments don't actually intersect, only the line that extends infinitely beyond them
        let thisY = solveFor(x: x)
        let onThis = a.y < b.y ? a.y <= thisY && thisY <= b.y : b.y <= thisY && thisY <= a.y

        let otherY = line.solveFor(x: x)
        let onOther = line.a.y < line.b.y ? line.a.y <= otherY && otherY <= line.b.y : line.b.y <= otherY && otherY <= line.a.y

        guard onThis && onOther else { return nil }
        return point
    }
}
