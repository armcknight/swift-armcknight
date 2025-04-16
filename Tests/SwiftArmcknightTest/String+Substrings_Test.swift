import SwiftArmcknight
import XCTest

final class String_Substrings_Test: XCTestCase {
    func testFindSubstringWhenSameEndStringAppearsBeforeAndAfterStartString() {
        let input = "abcdbe"
        let startQuery = "c"
        let endQuery = "b"
        let expectedSubstring = "d"
        let output = input.substring(from: startQuery, to: endQuery)
        XCTAssertEqual(expectedSubstring, output)
    }
}
