//
//  DateExt.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import Foundation

fileprivate var dateFormatter = DateFormatter()

extension Date {
    func convertDateToString() -> String {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = DateFormat.dateAndTime
        
        return dateFormatter.string(from: self)
    }
    
    func convertTimeToString() -> String {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        
        return dateFormatter.string(from: self)
    }
    
    static func currentDate() -> Self {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date())
        return calendar.date(from: components)!
    }
    
    func convertToEventHeader() -> String {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMMM yyyy"
        
        return dateFormatter.string(from: self)
    }
}
