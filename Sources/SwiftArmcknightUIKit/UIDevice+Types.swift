//
//  UIDevice+Types.swift
//  Pippin
//
//  Created by Andrew McKnight on 1/4/18.
//

#if canImport(UIKit)

import Foundation
import UIKit

public extension UIDevice {

    class func isSimulator() -> Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }

}

#endif
