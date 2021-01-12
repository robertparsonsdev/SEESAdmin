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
    
    init(id: String, data: [String: Any], type: FBDataType) {
        self.id = id
        self.data = data
        self.type = type
    }
    
    init(id: String, type: FBDataType) {
        self.type = type
        self.id = id
        
        switch type {
        case .students: self.data = FBStudent.emptyNodes
        default: self.data = [:]
        }
    }
    
    var path: String {
        return "/\(self.type)/\(self.id)"
    }
    
    var row: String {
        switch self.type {
        case .students: return "\(self.data[FBStudent.lastName.node] ?? "studentError"), \(self.data[FBStudent.firstName.node] ?? "studentError")"
        case .options: return self.data[FBOption.optionName] as? String ?? "optionError"
        case .events: return self.data[FBEvent.eventName] as? String ?? "eventError"
        case .contacts: return self.data[FBContact.name] as? String ?? "contactError"
        }
    }
    
    var section: String {
        switch self.type {
        case .students:
            let lastName = self.data[FBStudent.lastName.node] as! String
            if let letter = lastName.first {
                return String(letter).lowercased()
            } else {
                return "section-error"
            }
        case .options: return self.data[FBOption.majorName] as? String ?? "section-error" // lowercased
        case .events: return "events"
        case .contacts: return "contacts"
        }
    }
    
    var tableItems: [TableItem] {
        return TableItem.getItems(from: self.data)
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
            let lhsDateString = lhs.data[FBEvent.startDate] as! String, rhsDateString = rhs.data[FBEvent.startDate] as! String
            return lhsDateString.convertToDate() < rhsDateString.convertToDate()
        case .contacts: return lhs.row < rhs.row
        }
    }
}

struct TableItem {
    let header: String
    let row: String
    var editableView: EditableViewType = .textField
    
    static func getItems(from dictionary: [String: Any]) -> [Self] {
        var items: [TableItem] = []
        for (key, value) in dictionary {
            let row: String
            switch value {
            case is String: row = value as! String
            case is Int: row = String(value as! Int)
            default: row = "row-error"
            }
            
            switch key {
            case FBEvent.startDate, FBEvent.endDate: items.append(TableItem(header: key, row: row, editableView: .datePicker))
            default: items.append(TableItem(header: key, row: row))
            }
        }
        
        items.sort(by: { $0.header < $1.header })
        return items
    }
}

enum EditableViewType {
    case textField, datePicker
}
