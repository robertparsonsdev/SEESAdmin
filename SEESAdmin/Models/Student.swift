//
//  Student.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import UIKit

struct Student: DataProtocol, Hashable {
    let id: String
    let dataCase: SEESData = .students
    var path: String {
        return "/\(FirebaseValue.students)/\(self.id)"
    }
    var header: String {
        if let letter = self.lastName.first {
            return String(letter)
        } else {
            return "error"
        }
    }
    var row: String {
        return "\(self.lastName), \(self.firstName)"
    }
    
    var advisor: String = ""
    var advisorOffice: String = ""
    var broncoID: String = ""
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        setFBAttributes(with: dictionary)
    }
    
    init() {
        self.id = UUID().uuidString
    }
    
    var detailItems: [DetailTableItem] {
        var items: [DetailTableItem] = []
        items.append(DetailTableItem(header: FBStudent.advisor, row: self.advisor))
        items.append(DetailTableItem(header: FBStudent.advisorOffice, row: self.advisorOffice))
        items.append(DetailTableItem(header: FBStudent.broncoID, row: self.broncoID))
        items.append(DetailTableItem(header: FBStudent.email, row: self.email))
        items.append(DetailTableItem(header: FBStudent.firstName, row: self.firstName))
        items.append(DetailTableItem(header: FBStudent.lastName, row: self.lastName))
        return items
    }
    
    mutating func setFBAttributes(with dictionary: [String : Any]) {
        self.advisor = dictionary[FBStudent.advisor] as? String ?? "advisorError"
        self.advisorOffice = dictionary[FBStudent.advisorOffice] as? String ?? "advisorOfficeError"
        self.broncoID = dictionary[FBStudent.broncoID] as? String ?? "broncoIDError"
        self.email = dictionary[FBStudent.email] as? String ?? "emailError"
        self.firstName = dictionary[FBStudent.firstName] as? String ?? "firstNameError"
        self.lastName = dictionary[FBStudent.lastName] as? String ?? "lastNameError"
    }
}

extension Student: Comparable {
    static func < (lhs: Student, rhs: Student) -> Bool {
        return "\(lhs.lastName)\(lhs.firstName)" < "\(rhs.lastName)\(rhs.firstName)"
    }
}

protocol DataProtocol {
    init()
    init(id: String, dictionary: [String: Any])
    
    var id: String { get }
    var dataCase: SEESData { get }
    var path: String { get }
    
    var header: String { get }
    var row: String { get }
//    var listSort: Comparable { get }
    var detailItems: [DetailTableItem] { get }
    
//    var dataDictionary: [String: Any] { get }
    mutating func setFBAttributes(with dictionary: [String: Any])
}

struct DetailTableItem {
    let header: String
    let row: String
    var editableView: EditableViewType = .textField
}

enum EditableViewType {
    case textField, datePicker
}
