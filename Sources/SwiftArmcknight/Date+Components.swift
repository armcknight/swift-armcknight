//
//  Date+Components.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 8/26/18.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

public extension Date {
    func dateComponents() -> DateComponents {
        return Calendar.current.dateComponents(Set<Calendar.Component>(arrayLiteral: .day, .month, .year, .hour, .minute), from: self)
    }
    
    func dayMonthYearComponents() -> DateComponents {
        return Calendar.current.dateComponents(Set<Calendar.Component>(arrayLiteral: .day, .month, .year, .hour, .minute), from: self)
    }
}
