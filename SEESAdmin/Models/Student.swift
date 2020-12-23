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
    
    let advisor: String
    let advisorOffice: String
    let broncoID: String
    let email: String
    let firstName: String
    let lastName: String
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.advisor = dictionary[FBStudent.advisor] as? String ?? "advisorError"
        self.advisorOffice = dictionary[FBStudent.advisorOffice] as? String ?? "advisorOfficeError"
        self.broncoID = dictionary[FBStudent.broncoID] as? String ?? "broncoIDError"
        self.email = dictionary[FBStudent.email] as? String ?? "emailError"
        self.firstName = dictionary[FBStudent.firstName] as? String ?? "firstNameError"
        self.lastName = dictionary[FBStudent.lastName] as? String ?? "lastNameError"
    }
    
    init() {
        self.id = ""
        self.advisor = ""
        self.advisorOffice = ""
        self.broncoID = ""
        self.email = ""
        self.firstName = ""
        self.lastName = ""
    }
    
    var tableItems: [DataTableItem] {
        var items: [DataTableItem] = []
        items.append(DataTableItem(headerTitle: FBStudent.advisor, itemTitle: self.advisor))
        items.append(DataTableItem(headerTitle: FBStudent.advisorOffice, itemTitle: self.advisorOffice))
        items.append(DataTableItem(headerTitle: FBStudent.broncoID, itemTitle: self.broncoID))
        items.append(DataTableItem(headerTitle: FBStudent.email, itemTitle: self.email))
        items.append(DataTableItem(headerTitle: FBStudent.firstName, itemTitle: self.firstName))
        items.append(DataTableItem(headerTitle: FBStudent.lastName, itemTitle: self.lastName))
        return items
    }
}

protocol DataProtocol {
    init()
    init(id: String, dictionary: [String: Any])
    
    var id: String { get }
    var dataCase: SEESData { get }
    var path: String { get }
    var tableItems: [DataTableItem] { get }
    
//    var dataDictionary: [String: Any] { get }
}

struct DataTableItem {
    let headerTitle: String
    let itemTitle: String
    var editableView: EditableViewType = .textField
}

enum EditableViewType {
    case textField, datePicker
}
