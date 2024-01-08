//
//  String+CSV.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 1/8/19.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

public typealias CSVRow = [String]
public typealias CSV = [CSVRow]

public extension String {
    /// Split a String containing a CSV file's contents and split it into a 2-dimensional array of Strings, representing each row and its column fields.
    var csv: CSV {
        let rowComponents = split(separator: "\r\n").map({ (substring) -> String in
            return String(substring)
        })
        let valueRows = Array(rowComponents[1..<rowComponents.count]) // return all but header row
        let valueRowComponents: [CSVRow] = valueRows.map({ (row) -> [String] in
            let result = Array(row.split(separator: ",")).map({String($0)})
            return result
        })
        return valueRowComponents
    }
    
    /// For a CSV field surrounded by double quotes (like those that might contain a comma that should not delimit a next field), if it also contains a double quote within the field value, that double quote should be escaped by another double quote
    /// e.g. for a field containing the string `Quote: "I think, therefore I am"` would be rendered as `"Quote: ""I think, therefore I am"""`
    /// - seealso: https://stackoverflow.com/a/17808731 and https://www.ietf.org/rfc/rfc4180.txt
    var rfc4180CompliantFieldWithDoubleQuotes: String {
        guard count > 2 else { return self }
        let replacementRange = index(startIndex, offsetBy: 1)..<index(startIndex, offsetBy: count - 1)
        if self.first == "\"" && self.last == "\"" && self[replacementRange].contains("\"") && !self[replacementRange].contains("\"\"") {
            return replacingOccurrences(of: "\"", with: "\"\"", range: replacementRange)
        }
        return self
    }
}
