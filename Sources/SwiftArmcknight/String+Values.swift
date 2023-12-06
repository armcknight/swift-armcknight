//
//  String+Values.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 12/19/21.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

public extension String {
    var midpoint: Index {
        index(startIndex, offsetBy: count / 2)
    }

    /// Break up a multiline string containing integers 0-9 into a 2D array of those single digit integer values. Thus "`12\n34`" becomes `[[1, 2], [3, 4]]` and not `[[12], [34]]`.
    /// - precondition: Only digits 0-9 may appear; spaces or other characters produce undefined behavior, probably resulting in zeros.
    /// - precondition: The same amount of digits should be in eadh row.
    var intGrid: [[Int]] {
        return characterGrid.map { $0.map { String($0).integerValue } }
    }

    /// Given a string with numbers in multiple lines, return an array of those integer values. Thus "`12\n34`" becomes `[12, 34]`.
    var ints: [Int] {
        return lines.map({Int($0)!})
    }
    
    /// Return an array of tuples where each tuple corresponds to the parts of each line on the left and right side of a colon (":")
    @available(macOS 13.0, *)
    var keyValuePairs: [(String, String)] {
        lines.map { line in
            let parts = line.split(separator: ": ")
            return (String(parts[0]), String(parts[1]))
        }
    }

    /// Split a string by a delimiter and convert each element into an integer value.
    func ints(separator: Character) -> [Int] {
        split(separator: separator).map(\.integerValue)
    }

    /// Split a multiline string into strings containing an alphanumeric sequence and a number separated by a space into tuples containing their typed values.
    var stringsAndInts: [(String, Int)] {
        lines.map {
            let parts = $0.split(separator: " ")
            return (String(parts.first!), String(parts.last!).integerValue)
        }
    }

    var pairs: [(String, String)] {
        lines.map {
            let parts = $0.split(separator: " ")
            return (String(parts[0]), String(parts[1]))
        }
    }
}
