//
//  String+Plurals.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 8/26/18.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

public extension String {
    func pluralized<T: Numeric>(forValue value: T) -> String {
        if value == 1 { return self }
        else { return self + "s" }
    }
}
