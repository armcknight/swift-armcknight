//
//  Sum.swift
//  ProjectEuler
//
//  Created by Andrew McKnight on 1/11/16.
//  Copyright © 2016 AMProductions. All rights reserved.
//

import Foundation

public extension Sequence where Iterator.Element: AdditiveArithmetic {
    var sum: Iterator.Element {
        reduce((0 as! Self.Element), +)
    }
}

public extension Collection where Iterator.Element: AdditiveArithmetic, Self.Index == Int {
    /// Given an array, return the sums of values in windows of a specified size. For example,
    /// `[1, 2, 3, 4, 5]` with window sizes of `2` yields `[3, 5, 7, 9]`.
    func sums(windowSize: Int) -> [Iterator.Element] {
        windows(ofSize: windowSize).map(\.sum)
    }
}
