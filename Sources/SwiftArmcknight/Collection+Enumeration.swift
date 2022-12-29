//
//  Collection+Enumeration.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 12/16/22.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

// MARK: Generic 2D Collections
public extension Collection where Iterator.Element: Collection, Self.Index == Int, Iterator.Element.Index == Int {
    func enumerate<T>(rowStartOffset: Int = 0, rowEndOffset: Int = 0, colStartOffset: Int = 0, colEndOffset: Int = 0, _ block: (_ row: Int, _ col: Int, _ element: T) -> Void) {
        let rowEnd = count - rowEndOffset
        let colEnd = self[0].count - colEndOffset
        for rowIdx in rowStartOffset ..< rowEnd {
            for colIdx in colStartOffset ..< colEnd {
                block(rowIdx, colIdx, self[rowIdx][colIdx] as! T)
            }
        }
    }

    func enumerate<T>(allOffsets: Int = 0, _ block: (_ row: Int, _ col: Int, _ element: T) -> Void) {
        enumerate(rowStartOffset: allOffsets, rowEndOffset: allOffsets, colStartOffset: allOffsets, colEndOffset: allOffsets, block)
    }
}
