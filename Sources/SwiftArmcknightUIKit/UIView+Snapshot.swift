//
//  UIView+Snapshot.swift
//  Pippin
//
//  Created by Andrew McKnight on 1/2/19.
//

#if canImport(UIKit)

import UIKit

public extension UIView {
    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContext(frame.size)
        drawHierarchy(in: frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

#endif
