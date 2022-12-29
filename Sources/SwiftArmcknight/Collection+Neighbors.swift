//
//  Collection+Neighbors.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 12/16/22.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

// MARK: Generic 2D Collections
public extension Collection where Iterator.Element: Collection, Self.Index == Int, Iterator.Element.Index == Int {
    func sightLineRanges<T>(row: Int, col: Int) -> (rowLeft: [T], rowRight: [T], colUp: [T], colDown: [T]) {
        var colUpElements = [T]()
        for i in 0 ..< row {
            colUpElements.append(self[i][col] as! T)
        }

        var colDownElements = [T]()
        for i in row + 1 ..< count {
            colDownElements.append(self[i][col] as! T)
        }

        var rowLeftElements = [T]()
        let row = self[row]
        for i in 0 ..< col {
            rowLeftElements.append(row[i] as! T)
        }

        var rowRightElements = [T]()
        for i in col + 1 ..< row.count {
            rowRightElements.append(row[i] as! T)
        }

        return (rowLeftElements, rowRightElements, colUpElements, colDownElements)
    }

    typealias Neighbor4<T> = (up: T?, right: T?, down: T?, left: T?)

    /// Return the 4 values neighboring the value of this cell. Cells on edges of the grid have `nil` values for invalid neighbor locations.
    func neighbors4<T>(row: Int, col: Int) -> Neighbor4<T> {
        var left: T? = nil
        var up: T? = nil
        var down: T? = nil
        var right: T? = nil

        if col > 0 {
            left = self[row][col - 1] as! T?
        }
        if row > 0 {
            up = self[row - 1][col] as! T?
        }
        if col < self[row].count - 1 {
            right = self[row][col + 1] as! T?
        }
        if row < self.count - 1 {
            down = self[row + 1][col] as! T?
        }

        return (up: up, right: right, down: down, left: left)
    }

    /// Return the neighbors from `neighbors4(row:int:)` in an array in clockwise order starting from the value in the location directly above the specified location.
    func neighbors4Array<T>(row: Int, col: Int) -> [T] {
        let neighbors: Neighbor4<T> = neighbors4(row: row, col: col)
        return [neighbors.up, neighbors.right, neighbors.down, neighbors.left].compactMap { return $0 }
    }

    typealias Neighbor8<T> = (up: T?, upRight: T?, right: T?, rightDown: T?, down: T?, downLeft: T?, left: T?, leftUp: T?)

    /// Return the 8 values neighboring the value of this cell. Cells on edges of the grid have `nil` values for invalid neighbor locations.
    func neighbors8<T>(row: Int, col: Int) -> Neighbor8<T> {
        var left: T? = nil
        var upRight: T? = nil
        var up: T? = nil
        var rightDown: T? = nil
        var down: T? = nil
        var downLeft: T? = nil
        var right: T? = nil
        var leftUp: T? = nil

        if col > 0 {
            left = self[row][col - 1] as! T?
        }
        if row > 0 {
            up = self[row - 1][col] as! T?
        }
        if col < self[row].count - 1 {
            right = self[row][col + 1] as! T?
        }
        if row < self.count - 1 {
            down = self[row + 1][col] as! T?
        }

        if col > 0 && row > 0 {
            leftUp = self[row - 1][col - 1] as! T?
        }
        if col < self[row].count - 1 && row > 0 {
            upRight = self[row - 1][col + 1] as! T?
        }

        if col > 0 && row < count - 1 {
            downLeft = self[row + 1][col - 1] as! T?
        }
        if col < self[row].count - 1 && row < count - 1 {
            rightDown = self[row + 1][col + 1] as! T?
        }

        return (up: up, upRight: upRight, right: right, rightDown: rightDown, down: down, downLeft: downLeft, left: left, leftUp: leftUp)
    }

    /// Return the neighbors from `neighbors8(row:int:)` in an array in clockwise order starting from the value in the location directly above the specified location.
    func neighbors8Array<T>(row: Int, col: Int) -> [T] {
        let neighbors: Neighbor8<T> = neighbors8(row: row, col: col)
        return [neighbors.up, neighbors.upRight, neighbors.right, neighbors.rightDown, neighbors.down, neighbors.downLeft, neighbors.left, neighbors.leftUp].compactMap { return $0 }
    }
    
    func neighbors4Coordinates(row: Int, col: Int) -> [CGPoint] {
        var coords = [CGPoint]()
        if col > 0 {
            coords.append(CGPoint(x: Double(row), y: Double(col) - 1))
        }
        if row > 0 {
            coords.append(CGPoint(x: Double(row) - 1, y: Double(col)))
        }
        if col < self[row].count - 1 {
            coords.append(CGPoint(x: Double(row), y: Double(col) + 1))
        }
        if row < self.count - 1 {
            coords.append(CGPoint(x: Double(row) + 1, y: Double(col)))
        }
        return coords
    }

    func neighbors8Coordinates(row: Int, col: Int) -> [CGPoint] {
        var coords = [CGPoint]()
        if col > 0 {
            coords.append(CGPoint(x: Double(row), y: Double(col) - 1))
        }
        if row > 0 {
            coords.append(CGPoint(x: Double(row) - 1, y: Double(col)))
        }
        if col < self[row].count - 1 {
            coords.append(CGPoint(x: Double(row), y: Double(col) + 1))
        }
        if row < self.count - 1 {
            coords.append(CGPoint(x: Double(row) + 1, y: Double(col)))
        }

        if col > 0 && row > 0 {
            coords.append(CGPoint(x: Double(row) - 1, y: Double(col) - 1))
        }
        if col < self[row].count - 1 && row > 0 {
            coords.append(CGPoint(x: Double(row) - 1, y: Double(col) + 1))
        }

        if col > 0 && row < count - 1 {
            coords.append(CGPoint(x: Double(row) + 1, y: Double(col) - 1))
        }
        if col < self[row].count - 1 && row < count - 1 {
            coords.append(CGPoint(x: Double(row) + 1, y: Double(col) + 1))
        }
        return coords
    }
}

// needed to create arrays of CGPoints for neighbors4Coordinates/neighbors8Coordinates
extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine("(x: \(x), y: \(y))")
    }
}
