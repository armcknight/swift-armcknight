//
//  ULLONG_MAX.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 2/26/17.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

/// ULLONG_MAX is not currently defined in Swift.
let ULLONG_MAX = UInt64(2) * UInt64(LLONG_MAX) + UInt64(1)
