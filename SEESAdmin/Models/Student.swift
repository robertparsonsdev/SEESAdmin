//
//  Student.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import UIKit

struct Student: DataProtocol, Hashable {
    var dataCase: SEESData = .students
    
    let advisor: String
    let advisorOffice: String
    let broncoID: String
    let email: String
    let firstName: String
    let lastName: String
    
    init(dictionary: [String: Any]) {
        self.advisor = dictionary[FBUser.advisor] as? String ?? "advisorError"
        self.advisorOffice = dictionary[FBUser.advisorOffice] as? String ?? "advisorOfficeError"
        self.broncoID = dictionary[FBUser.broncoID] as? String ?? "broncoIDError"
        self.email = dictionary[FBUser.email] as? String ?? "emailError"
        self.firstName = dictionary[FBUser.firstName] as? String ?? "firstNameError"
        self.lastName = dictionary[FBUser.lastName] as? String ?? "lastNameError"
    }
    
    init() {
        self.advisor = ""
        self.advisorOffice = ""
        self.broncoID = ""
        self.email = ""
        self.firstName = ""
        self.lastName = ""
    }
    
    var tableItems: [DataTableItem] {
        var items: [DataTableItem] = []
        items.append(DataTableItem(headerTitle: FBUser.advisor, itemTitle: self.advisor))
        items.append(DataTableItem(headerTitle: FBUser.advisorOffice, itemTitle: self.advisorOffice))
        items.append(DataTableItem(headerTitle: FBUser.broncoID, itemTitle: self.broncoID))
        items.append(DataTableItem(headerTitle: FBUser.email, itemTitle: self.email))
        items.append(DataTableItem(headerTitle: FBUser.firstName, itemTitle: self.firstName))
        items.append(DataTableItem(headerTitle: FBUser.lastName, itemTitle: self.lastName))
        return items
    }
}

protocol DataProtocol {
    init()
    init(dictionary: [String: Any])
    var tableItems: [DataTableItem] { get }
    var dataCase: SEESData { get }
}

struct DataTableItem {
    let headerTitle: String
    let itemTitle: String
    var editableView: EditableViewType = .textField
}

enum EditableViewType {
    case textField, datePicker
}
