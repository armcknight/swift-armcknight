import XCTest
@testable import SwiftArmcknight

class Double_Formatting_Test: XCTestCase {

    func testWholeNumberTrimsAllDecimals() {
        XCTAssertEqual((7.0).formatted(maxDecimals: 2), "7")
        XCTAssertEqual((100.0).formatted(maxDecimals: 3), "100")
    }

    func testFractionalValueTrimsTrailingZeros() {
        XCTAssertEqual((7.5).formatted(maxDecimals: 2), "7.5")
        XCTAssertEqual((7.50).formatted(maxDecimals: 2), "7.5")
        XCTAssertEqual((1.230).formatted(maxDecimals: 3), "1.23")
    }

    func testSignificantDecimalsPreserved() {
        XCTAssertEqual((7.25).formatted(maxDecimals: 2), "7.25")
        XCTAssertEqual((3.141).formatted(maxDecimals: 3), "3.141")
    }

    func testZeroDecimalsAllowed() {
        XCTAssertEqual((42.9).formatted(maxDecimals: 0), "43")
    }

    func testMaxDecimalsRespected() {
        XCTAssertEqual((7.123456).formatted(maxDecimals: 2), "7.12")
    }

}
