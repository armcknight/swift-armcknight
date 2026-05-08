import Foundation

public extension Double {
    func formatted(maxDecimals: Int) -> String {
        var s = String(format: "%.\(maxDecimals)f", self)
        if s.contains(".") {
            while s.hasSuffix("0") { s.removeLast() }
            if s.hasSuffix(".") { s.removeLast() }
        }
        return s
    }
}
