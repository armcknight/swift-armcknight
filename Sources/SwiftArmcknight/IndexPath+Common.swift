//
//  IndexPath+Common.swift
//  PippinTests
//
//  Created by Andrew McKnight on 3/18/17.
//
//

import Foundation

public extension IndexPath {
    static var zero: IndexPath {
        get {
            return IndexPath(indexes: [0, 0])
        }
    }
}
