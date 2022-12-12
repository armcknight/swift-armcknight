//
//  Set+ConversationalList.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 4/19/20.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

public extension Set {
    var conversationalList: String? {
        return Array(self).conversationalList
    }
}
