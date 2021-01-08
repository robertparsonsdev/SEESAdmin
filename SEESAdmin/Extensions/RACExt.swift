//
//  RACExt.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 1/5/21.
//

import Foundation

extension RandomAccessCollection where Element: Comparable {
    func getInsertionIndex(of element: Element) -> Index {
        var slice: SubSequence = self[...]
        
        while !slice.isEmpty {
            let middleIndex = slice.index(slice.startIndex, offsetBy: slice.count / 2)
            if element < slice[middleIndex] {
                slice = slice[..<middleIndex]
            } else {
                slice = slice[index(after: middleIndex)...]
            }
        }
        
        return slice.startIndex
    }
}

extension Array {
    public func getItemAt(_ index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}
