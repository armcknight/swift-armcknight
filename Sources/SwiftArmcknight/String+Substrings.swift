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

    /// - returns: the substring between the two provided strings (not inclusive).
    func substring(from: String, to: String) -> String {
        let startRange = (self as NSString).range(of: from)
        let endRange = (self as NSString).range(of: to)
        let startIdx = self.index(self.startIndex, offsetBy: (startRange.location + startRange.length))
        let endIdx = self.index(self.startIndex, offsetBy: endRange.location)
        return String(self[startIdx ..< endIdx]).trimmingCharacters(in: .newlines)
    }

    var halves: (String, String) {
        (String(self[startIndex ..< midpoint]), String(self[midpoint ..< endIndex]))
    }
}
