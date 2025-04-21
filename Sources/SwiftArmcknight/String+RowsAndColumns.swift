//
//  String+RowsAndColumns.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 12/16/22.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

// MARK: Arrays of Strings
public extension Array<String> {
    /**
     * Given columnar input, return an array of columns, each of which is represented as an array of its elements.
     * For example, given the array of strings:
     * ```
     * [
     *  "a b c",
     *  "d e f",
     *  "g h i"
     * ]
     * ```
     * the result is `[["a", "d", "g"], ["b", "e", "h"], ["c", "f", "i"]]`.
     */
    var columns: [[String]] {
        guard count > 0 else { return [] }
        var columns = [[String]]()
        let numberOfCols = first!.components(separatedBy: .whitespaces).count
        for _ in 0 ..< numberOfCols {
            columns.append([String]())
        }
        forEach {
            let colElements = $0.components(separatedBy: .whitespaces)
            assert(colElements.count == numberOfCols)
            for i in 0 ..< numberOfCols {
                columns[i].append(colElements[i])
            }
        }
        return columns
    }

    /// - note: If input is not rectangular, but rather has a ragged right edge, the right ends of strings are padded with whitespace to the length of the longest string.
    /// - returns: A character-by-character transposition of an array of strings.
    var transpose: [[String]] {
        guard count > 0 else { return [] }
        guard count > 1 else { return [Array(self)] }
        var rectified = self

        let lengths = map { $0.count }
        if Set(lengths).count > 1 {
            let longest = lengths.sorted().last!
            rectified = map {
                $0.appending(String(repeating: " ", count: longest - $0.count))
            }
        }

        var result = Array<[String]>(repeating: Array<String>(repeating: " ", count: rectified.count), count: rectified[0].count)
        let matrix = rectified.map { $0.map { String($0) } }
        matrix.enumerate { row, col, element in
            result[col][row] = element
        }

        return result
    }
}

public extension String {
    /// Break up a multiline string into an array of each line's string value.
    var lines: [String] {
        return split(separator: "\n").map({String($0)})
    }
    
    /// Break up a multiline string into an array of arrays of lines belonging to paragraphs separated by empty lines in the original string.
    @available(macOS 13.0, iOS 16.0, *)
    var paragraphs: [[String]] {
        split(separator: "\n\n").map { substring in
            substring.split(separator: "\n")
        }.map { $0.map { String($0) } }
    }

    /// Break up a multiline string into a 2D array of all the characters. Thus '"`abc\ndef\nghi`" becomes `[['a', 'b', 'c'],['d', 'e', 'f'], ['g', 'h', 'i']]`.
    var characterGrid: [[String]] {
        return lines.map {
            return $0.map({String($0)})
        }
    }

    /**
     * Given columnar input, return an array of columns, each of which is represented as an array of its elements.
     * For example, given the string:
     * ```
     * """
     * a b c
     * d e f
     * g h i
     * """
     * ```
     * the result is `[["a", "d", "g"], ["b", "e", "h"], ["c", "f", "i"]]`.
     * - warning: The strings must all have the same number of elements delimited by whitespace.
     */
    var columns: [[String]] {
        guard count > 0 else { return [] }
        return lines.columns
    }

    var transpose: [[String]] {
        return lines.transpose
    }
}
