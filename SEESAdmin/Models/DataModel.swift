//
//  DataModel.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 1/5/21.
//

import Foundation

struct DataModel: Identifiable {
    let id: String
    var data: [String: Any]
    let type: FBDataType
    
    var path: String {
        return "/\(self.type)/\(self.id)"
    }
    
    var row: String {
        switch self.type {
        case .students: return "\(self.data[FBStudent.lastName.key] ?? "studentError"), \(self.data[FBStudent.firstName.key] ?? "studentError")"
        case .options: return self.data[FBOption.optionName.key] as? String ?? "optionError"
        case .events: return self.data[FBEvent.eventName.key] as? String ?? "eventError"
        case .contacts: return self.data[FBContact.fullName.key] as? String ?? "contactError"
        }
    }
    
    var section: String {
        switch self.type {
        case .students:
            let lastName = self.data[FBStudent.lastName.key] as! String
            if let letter = lastName.first {
                return String(letter).lowercased()
            } else {
                return "section-error"
            }
        case .options: return self.data[FBOption.majorName.key] as? String ?? "section-error" // lowercased
        case .events: return "events"
//            let dateString = self.data[FBEvent.date.key] as! String
//            let date = dateString.convertToDate()
//            let month = Calendar.current.component(.month, from: date)
//            let year = Calendar.current.component(.year, from: date)
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "LLLL"
//            return "\(year * 2 + month) \(dateFormatter.string(from: date))"
        case .contacts: return "contacts"
        }
    }
    
    var tableItems: [TableItem] {
        return TableItem.getItems(from: self.data, for: self.type)
    }
}

extension DataModel: Equatable {
    static func == (lhs: DataModel, rhs: DataModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension DataModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension DataModel: Comparable {
    static func < (lhs: DataModel, rhs: DataModel) -> Bool {
        guard lhs.type == rhs.type else { return false }
        
        switch lhs.type {
        case .students: return lhs.row < rhs.row
        case .options: return lhs.row < rhs.row
        case .events:
            let lhsDateString = lhs.data[FBEvent.date.key] as! String, rhsDateString = rhs.data[FBEvent.date.key] as! String
            return lhsDateString.convertToDate() < rhsDateString.convertToDate()
        case .contacts: return lhs.row < rhs.row
        }
    }
}

struct TableItem {
    let header: String
    let row: String
    var editableView: EditableViewType = .textField
    
    static func getItems(from dictionary: [String: Any], for type: FBDataType) -> [Self] {
        var items: [TableItem] = []
        let dataCases: [FBDataProtocol]
        switch type {
        case .students: dataCases = FBStudent.allCases
        case .options: dataCases = FBOption.allCases
        case .events: dataCases = FBEvent.allCases
        case .contacts: dataCases = FBContact.allCases
        }
        
        for dataCase in dataCases {
            let header = dataCase.key
            let row: String
            
            if let value = dictionary[header] {
                switch value {
                case is String: row = value as! String
                case is Int: row = String(value as! Int)
                default: row = "row-error"
                }
            } else {
                row = "row-error"
            }
            
            switch header {
            case FBEvent.date.key:
                items.append(TableItem(header: header, row: row, editableView: .datePicker))
            case FBOption.majorName.key:
                items.append(TableItem(header: header, row: row, editableView: .tableView))
            case FBContact.monday.key, FBContact.tuesday.key, FBContact.wednesday.key, FBContact.thursday.key, FBContact.friday.key:
                items.append(TableItem(header: header, row: row, editableView: .timeRange))
            default:
                items.append(TableItem(header: header, row: row))
            }
        }
        
        return items
    }
}

enum EditableViewType {
    case textField, datePicker, tableView, timeRange
}
