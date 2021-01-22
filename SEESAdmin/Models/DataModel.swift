//
//  DataModel.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 1/5/21.
//

import Foundation

struct DataModel: Identifiable {
    let id: String
    var data: [String: String]
    let type: FBDataType
    
    var path: String {
        return "/\(self.type)/\(self.id)"
    }
    
    var row: String {
        switch self.type {
        case .students: return "\(self.data[FBStudent.lastName.key] ?? "studentError"), \(self.data[FBStudent.firstName.key] ?? "studentError")"
        case .options: return self.data[FBOption.optionName.key] ?? "optionError"
        case .events: return self.data[FBEvent.eventName.key] ?? "eventError"
        case .contacts: return self.data[FBContact.fullName.key] ?? "contactError"
        }
    }
    
    var section: String {
        switch self.type {
        case .students:
            if let lastName = self.data[FBStudent.lastName.key] {
                if let letter = lastName.first {
                    return String(letter).lowercased()
                }
            }
            return "last name initial error"
        case .options:
            return self.data[FBOption.majorName.key]?.lowercased() ?? "major name error"
        case .events:
            if let dateString = self.data[FBEvent.date.key] {
                let date = dateString.convertToDate()
                return date.convertToEventHeader()
            }
            return "event date error"
        case .contacts:
            return "contacts"
        }
    }
    
    var tableItems: [TableItem] {
        switch self.type {
        case .students:
            return TableItem.getItems(from: self.data, for: FBStudent.allCases)
        case .options:
            return TableItem.getItems(from: self.data, for: FBOption.allCases)
        case .events:
            return TableItem.getItems(from: self.data, for: FBEvent.allCases)
        case .contacts:
            return TableItem.getItems(from: self.data, for: FBContact.allCases)
        }
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
        case .students:
            return lhs.row < rhs.row
        case .options:
            return lhs.row < rhs.row
        case .events:
            let lhsDateString = lhs.data[FBEvent.date.key]!, rhsDateString = rhs.data[FBEvent.date.key]!
            return lhsDateString.convertToDate() < rhsDateString.convertToDate()
        case .contacts:
            if let leftOrder = lhs.data[FBContact.order.key], let rightOrder = rhs.data[FBContact.order.key] {
                if let leftInt = Int(leftOrder), let rightInt = Int(rightOrder) {
                    return leftInt < rightInt
                }
            }
            return lhs.row < rhs.row
        }
    }
}

struct TableItem {
    let header: String
    let row: String
    var editableView: EditableViewType = .textField
    
    static func getItems(from dictionary: [String: String], for types: [FBDataProtocol]) -> [Self] {
        var items: [TableItem] = []
        
        for type in types {
            let header = type.key
            let row: String
            
            if let value = dictionary[header] {
                row = value
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
