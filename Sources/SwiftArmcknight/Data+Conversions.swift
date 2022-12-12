//
//  Data+Conversions.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 7/27/17.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

enum DataConversionError: Error {
    case failedConvertingDataToString
    case filedConvertingStringToData
}

public extension Data {

    func toString() throws -> String {
        let nsdata = self as NSData
        guard let string = NSString(bytes: nsdata.bytes, length: nsdata.length, encoding: String.Encoding.utf8.rawValue) as String? else {
            throw DataConversionError.failedConvertingDataToString
        }
        return string
    }

}

public extension String {

    func toData() throws -> Data {
        guard let data = self.data(using: String.Encoding.utf8) else {
            throw DataConversionError.filedConvertingStringToData
        }
        return data
    }

}
