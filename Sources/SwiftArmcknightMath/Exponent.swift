//
//  Exponent.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 1/11/16.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

precedencegroup ExponentiationPrecedence {
    associativity: right
    higherThan: MultiplicationPrecedence
}

infix operator **: ExponentiationPrecedence

// Integer case

public func **<T>(base: T, power: T) -> T where T: BinaryInteger {
    return exponentiate(base, power)
}

func exponentiate<T>(_ base: T, _ power: T) -> T where T: BinaryInteger {
    if power == 0 { return 1 }
    var result = base
    var mutablePower = power
    while mutablePower > 1 {
        result *= base
        mutablePower -= 1 as T
    }
    return result
}

// Floating-point cases

/// applies to `Float` and `Float32`
func **(base: Float, power: Float) -> Float {
    return powf(base, power)
}

/// applies to `Double` and `Float64`
func **(base: Double, power: Double) -> Double {
    return pow(base, power)
}
