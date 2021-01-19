//
//  DateExt.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import Foundation

extension Date {
    func convertDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateAndTime
        
        return dateFormatter.string(from: self)
    }
    
    func convertTimeToString() -> String {
        let dateFormatter = DateFormatter()
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
}
