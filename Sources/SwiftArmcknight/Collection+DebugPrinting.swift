//
//  Collection+DebugPrinting.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 12/16/22.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

public extension Collection where Element == Array<String> {
    func printGrid() {
        let separator = String(repeating: "-", count: first!.count * 2 - 1)
        let output = map({ row in
            row.joined(separator: " ")
        }).joined(separator: "\n")
        print("\(separator)\n\(output)\n\(separator)\n")
    }
}

public extension Collection where Element == Array<(any Comparable)?> {
    func gridDescription(valueTransformer: ((Element.Element) -> String)? = nil) -> String {
        return map({ row in
            if let valueTransformer {
                return row.map { valueTransformer($0) }.joined(separator: " ")
            } else {
                return row.map { String(describing: $0) }.joined(separator: " ")
            }
        }).joined(separator: "\n")
    }

    func printGrid(valueTransformer: ((Element.Element) -> String)? = nil) {
        let separator = String(repeating: "-", count: first!.count * 2 - 1)
        print("\(separator)\n\(gridDescription(valueTransformer: valueTransformer))\n\(separator)\n")
    }
}
