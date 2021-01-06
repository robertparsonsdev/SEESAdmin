//
//  DataModel.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 1/5/21.
//

import Foundation

struct DataModel {
    let id: String
    var data: [String: Any]
    let type: FBDataType
    
    var path: String {
        var pathName = "/"
        switch self.type {
        case .students: pathName.append(FBDataType.students.rawValue)
        case .options: pathName.append(FBDataType.options.rawValue)
        case .events: pathName.append(FBDataType.events.rawValue)
        case .contacts: pathName.append(FBDataType.contacts.rawValue)
        }
        return pathName.appending("/\(self.id)")
    }
    
    var row: String {
        switch self.type {
        case .students: return "\(self.data[FBStudent.lastName] ?? "studentError"), \(self.data[FBStudent.firstName] ?? "studentError")"
        case .options: return self.data[FBOption.optionName] as? String ?? "optionError"
        case .events: return self.data[FBEvent.eventName] as? String ?? "eventError"
        case .contacts: return self.data[FBContact.name] as? String ?? "contactError"
        }
    }
    
    var header: String {
        switch self.type {
        case .students:
            let lastName = self.data[FBStudent.lastName] as! String
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
    
    var detailItems: [DetailTableItem] {
        var items: [DetailTableItem] = []
        for (key, value) in self.data {
            switch key {
            case FBEvent.startDate, FBEvent.endDate: items.append(DetailTableItem(header: key, row: value as! String, editableView: .datePicker))
            default: items.append(DetailTableItem(header: key, row: value as! String))
            }
        }
        
        items.sort(by: { $0.header < $1.header })
        return items
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
        case .students: return "\(lhs.data[FBStudent.lastName]!)\(lhs.data[FBStudent.firstName]!)" < "\(rhs.data[FBStudent.lastName]!)\(rhs.data[FBStudent.firstName]!)"
        case .options: return lhs.row < rhs.row
        case .events:
            let lhsDateString = lhs.data[FBEvent.startDate] as! String, rhsDateString = rhs.data[FBEvent.startDate] as! String
            return lhsDateString.convertToDate() < rhsDateString.convertToDate()
        case .contacts: return lhs.row < rhs.row
        }
    }
}

struct DetailTableItem {
    let header: String
    let row: String
    var editableView: EditableViewType = .textField
}

enum EditableViewType {
    case textField, datePicker
}
