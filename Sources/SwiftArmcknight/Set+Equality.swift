//
//  Set+Equality.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 11/30/18.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

public extension Set {
    func containsSameElements(as set: Set) -> Bool {
        let difference = symmetricDifference(set)
        return difference.count == 0
    }
}
