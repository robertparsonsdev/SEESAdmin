//
//  Student.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import Foundation

struct Student: DataProtocol, Hashable {
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
    
    var tableItems: [DataTableItem] {
        var items: [DataTableItem] = []
        items.append(DataTableItem(section: FBUser.advisor, value: self.advisor))
        items.append(DataTableItem(section: FBUser.advisorOffice, value: self.advisorOffice))
        items.append(DataTableItem(section: FBUser.broncoID, value: self.broncoID))
        items.append(DataTableItem(section: FBUser.email, value: self.email))
        items.append(DataTableItem(section: FBUser.firstName, value: self.firstName))
        items.append(DataTableItem(section: FBUser.lastName, value: self.lastName))
        return items
    }
}

protocol DataProtocol {
    init(dictionary: [String: Any])
    var tableItems: [DataTableItem] { get }
}

struct DataTableItem {
    let section: String
    let value: String
}
