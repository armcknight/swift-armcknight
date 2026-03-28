//
//  UILabel+Layout.swift
//  Pippin
//
//  Created by Andrew McKnight on 12/6/17.
//

#if canImport(UIKit)

import UIKit

public extension UILabel {
    func allowShrinking(downTo minimumScale: CGFloat, withTightening: Bool) {
        allowsDefaultTighteningForTruncation = withTightening
        minimumScaleFactor = minimumScale
        adjustsFontSizeToFitWidth = true
    }
}

#endif
