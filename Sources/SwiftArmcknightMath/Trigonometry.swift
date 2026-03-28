//
//  Trigonometry.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 9/11/18.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

public enum TrigonometricRatio: Int {
    case arc
    case hypotenuse
    case chord
    
    case sine
    case cosine
    case tangent
    
    case sineOpposite
    case cosineOpposite
    
    case secant
    case cosecant
    case cotangent
    
    case versine
    case coversine
    
    case exsecant
    case excosecant
    
    public func shortName() -> String {
        switch self {
        case .arc: return "arc"
        case .hypotenuse: return "hyp"
        case .chord: return "crd"
        case .sine, .sineOpposite: return "sin"
        case .cosine, .cosineOpposite: return "cos"
        case .tangent: return "tan"
        case .secant: return "sec"
        case .cosecant: return "csc"
        case .cotangent: return "cot"
        case .versine: return "siv"
        case .coversine: return "cvs"
        case .exsecant: return "exsec"
        case .excosecant: return "excsc"
        }
    }
    
    public func longName() -> String {
        switch self {
        case .arc: return "Arc"
        case .hypotenuse: return "Hypotenuse"
        case .chord: return "Chord"
        case .sine: return "Sine"
        case .cosine: return "Cosine"
        case .sineOpposite: return "Opposite Sine"
        case .cosineOpposite: return "Opposite Cosine"
        case .tangent: return "Tangent"
        case .secant: return "Secant"
        case .cosecant: return "Cosecant"
        case .cotangent: return "Cotangent"
        case .versine: return "Versine"
        case .coversine: return "Coversine"
        case .exsecant: return "Exsecant"
        case .excosecant: return "Excosecant"
        }
    }
    
    public static func allRatios() -> [TrigonometricRatio] {
        return [
            arc, hypotenuse, chord, sine, sineOpposite, cosineOpposite, cosine, tangent, secant, cosecant, cotangent, versine, coversine, exsecant, excosecant
        ]
    }

    public func solve(for angle: Angle) -> Double {
        switch self {
        case .arc: return angle.radians
        case .hypotenuse: return 1 // hardcoded for unit circle; TODO: generalize
        case .chord: return hypot(TrigonometricRatio.versine.solve(for: angle), TrigonometricRatio.sine.solve(for: angle))
        case .sine: return sin(angle.radians)
        case .cosine: return cos(angle.radians)
        case .sineOpposite: return TrigonometricRatio.sine.solve(for: angle)
        case .cosineOpposite: return TrigonometricRatio.cosine.solve(for: angle)
        case .tangent: return tan(angle.radians)
        case .secant:
            let cosine = TrigonometricRatio.cosine.solve(for: angle)
            return cosine == 0 ? Double.nan : 1 / cosine
        case .cosecant:
            let sine = TrigonometricRatio.sine.solve(for: angle)
            return sine == 0 ? Double.nan : 1 / sine
        case .cotangent:
            let tangent = TrigonometricRatio.tangent.solve(for: angle)
            return tangent == 0 ? Double.nan : 1 / tangent
        case .versine: return 1 - TrigonometricRatio.cosine.solve(for: angle)
        case .coversine: return 1 - TrigonometricRatio.sine.solve(for: angle)
        case .exsecant:
            let secant = TrigonometricRatio.secant.solve(for: angle)
            return secant.isNaN ? Double.nan : secant - 1
        case .excosecant:
            let cosecant = TrigonometricRatio.cosecant.solve(for: angle)
            return cosecant.isNaN ? Double.nan : cosecant - 1
        }
    }
}
