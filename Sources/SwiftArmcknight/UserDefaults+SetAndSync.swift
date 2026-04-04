//
//  UserDefaults+SetAndSync.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 9/13/18.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

public extension UserDefaults {
    class func setAndSynchronize(key: String, value: Any?) {
        standard.set(value, forKey: key)
        standard.synchronize()
    }

    func setAndSynchronize(key: String, value: Any?) {
        set(value, forKey: key)
        synchronize()
    }
}
