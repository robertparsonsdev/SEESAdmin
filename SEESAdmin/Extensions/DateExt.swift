//
//  DateExt.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import Foundation

extension Date {
    func convertToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateAndTime
        
        return dateFormatter.string(from: self)
    }
}
