//
//  UIImage+BundleLoading.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 1/2/18.
//

#if canImport(UIKit)
import UIKit

public extension UIImage {
    /// Loads a named image from the specified bundle.
    convenience init?(named name: String, in bundle: Bundle) {
        self.init(named: name, in: bundle, compatibleWith: nil)
    }
}
#endif
