//
//  UITextField+Empty.swift
//  PippinLibrary
//
//  Created by Andrew McKnight on 7/27/17.
//  Copyright © 2019 Two Ring Software. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UITextField {

    var isEmpty: Bool {
        return text == nil || text == ""
    }

    /**
     By default, `UITextField` will return an empty string `""` if `text` is `nil`. This avoids getting an empty string for a textfield that really has nil text.
     */
    var nonemptyText: String? {
        return isEmpty ? nil : text
    }

}

#endif
