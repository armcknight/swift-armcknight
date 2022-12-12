//
// Logging.swift
// swift-armcknight
//
//  Created by Andrew McKnight on 11/20/17.
//

import Foundation

public struct Logging {

    /// Optionally provide a block for library functions to log details of its work.
    public static var logBlock: ((String) -> Void)?

}

internal func log(_ message: String) {
    #if DEBUG
    Logging.logBlock?(message)
    #endif
}
