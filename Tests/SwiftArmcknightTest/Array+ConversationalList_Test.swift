//
//  Array+ConversationalList_Test.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 4/19/20.
//  Copyright © Andrew McKnight 2016-2022
//

import XCTest

class Array_ConversationalList_Test: XCTestCase {
    func testConversationalList() {
        XCTAssertNil([].conversationalList)

        [
            [
                "input": [1],
                "expected": "1",
            ],
            [
                "input": [1, 2],
                "expected": "1 and 2",
            ],
            [
                "input": [1, 2, 3, 4],
                "expected": "1, 2, 3 and 4",
            ],
            [
                "input": [1, 1],
                "expected": "1 and 1",
            ],
            ].forEach { testCase in
                let input = testCase["input"] as! [Int]
                let expected = testCase["expected"] as! String
                XCTAssertEqual(input.conversationalList!, expected)
        }
    }
}
