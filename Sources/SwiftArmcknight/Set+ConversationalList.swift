//
//  Set+ConversationalList.swift
// swift-armcknightLibrary
//
//  Created by Andrew McKnight on 4/19/20.
//

import Foundation

public extension Set {
    var conversationalList: String? {
        return Array(self).conversationalList
    }
}
