//
//  String+Substrings.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 12/19/21.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

public extension String {
    func substrings(ofLength length: Int) -> [String] {
        let chars = Array(self)
        var substrings = [String]()
        for i in 0 ... (chars.count - length) {
            var substring = String()
            for j in 0 ..< length {
                let char = String(chars[i + j])
                substring.append(char)
            }
            substrings.append(substring)
        }
        return substrings
    }
}
