//
//  Bases.swift
// swift-armcknight
//
//  Created by Andrew McKnight on 12/2/21.
//

import Foundation

public extension String {
    /// Calculate the integer value of a binary number described in this string.
    var decimalValueOfBinary: Int {
        var i = 0
        return reversed().reduce(into: 0) { (result, next) in
            if next == "1" {
                result += 2 ** i
            }
            i += 1
        }
    }
}

public extension Array where Element == Int {
    /// Calculate the integer value of a binary number described in this array.
    var decimalValueOfBinary: Int {
        var i = 0
        return reversed().reduce(into: 0) { (result, next) in
            result += next * 2 ** i
            i += 1
        }
    }
}
