//
//  File.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 4/19/20.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

public extension Collection where Element: Hashable, Self.Index == Int {
    /// - SeeAlso: https://gist.github.com/JadenGeller/6174b3461a34465791c5#file-powerset_flatmap-swift
    var powerSet: Set<Set<Element>> {
        guard !isEmpty else { return Set([.empty]) }
        return Set(Array(self[1...]).powerSet.flatMap {
            Set([$0, Set([self[0]]).union($0)])
        })
    }

    /// - SeeAlso: https://gist.github.com/JadenGeller/6174b3461a34465791c5#file-powerset_map-swift
    var powerSetTail: Set<Set<Element>> {
        guard !isEmpty else { return Set([.empty]) }
        let tailPowerSet = Array(self[1...]).powerSetTail
        let base = Set(tailPowerSet.map { Set([self[0]] + $0) })
        let combined = base.union(tailPowerSet)
        return combined
    }
}


