//
//  String+rDNS.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 3/5/17.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

public extension String {
    init(asRDNSWithSubpaths subpaths: [String]) {
        precondition(subpaths.count > 0)
        precondition(subpaths.filter({ $0.count > 0 }).count > 0)
        self = subpaths.joined(separator: ".")

    }

    init(asRDNSForCurrentAppWithSubpaths subpaths: [String]) {
        self = String(asRDNSWithSubpaths: [Bundle.main.identifier] + subpaths)
    }
}
