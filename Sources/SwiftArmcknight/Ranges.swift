//
//  Ranges.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 12/16/22.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

public extension ClosedRange {
    func overlaps(other: ClosedRange) -> Bool {
        lowerBound <= other.lowerBound && lowerBound >= other.upperBound
        || upperBound >= other.lowerBound && upperBound <= other.upperBound
    }
}
