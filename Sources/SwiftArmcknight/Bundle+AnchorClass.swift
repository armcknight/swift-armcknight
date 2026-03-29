//
//  Bundle+AnchorClass.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 12/19/19.
//

import Foundation

public extension Bundle {
    /// Returns the bundle containing the given class, useful for locating
    /// resources shipped alongside a framework or package target.
    static func bundle(for anchorClass: AnyClass) -> Bundle {
        return Bundle(for: anchorClass)
    }
}
