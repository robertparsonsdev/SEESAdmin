//
//  StringExt.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//  Copyright © 2020 Robert Parsons. All rights reserved.
//

import Foundation

extension String {
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
    
    func convertToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateAndTime
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.date(from: self) ?? Date.currentDate()
    }
    
    func converToTime() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        return dateFormatter.date(from: self) ?? Date.currentDate()
    }
}
