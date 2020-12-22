//
//  Contact.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import Foundation

struct Contact: DataProtocol, Hashable {
    let dataCase: SEESData = .contacts
    
    var name: String = ""
    var title: String = ""
    var office: String = ""
    var phone: String = ""
    var email: String = ""
    var order: Int = 0
    var image: ContactImage
//    let notes: String
    
    let monday: String
    let tuesday: String
    let wednesday: String
    let thursday: String
    let friday: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary[FBContact.name] as? String ?? "nameError"
        self.title = dictionary[FBContact.title] as? String ?? "titleError"
        self.office = dictionary[FBContact.office] as? String ?? "officeError"
        self.phone = dictionary[FBContact.phone] as? String ?? "phoneError"
        self.email = dictionary[FBContact.email] as? String ?? "emailError"
        self.order = dictionary[FBContact.order] as? Int ?? -1
        self.image = self.name.lowercased().contains("alas") ? .alas : .dora
        
        self.monday = dictionary[FBContact.monday] as? String ?? "mondayError"
        self.tuesday = dictionary[FBContact.tuesday] as? String ?? "tuesdayError"
        self.wednesday = dictionary[FBContact.wednesday] as? String ?? "wednesdayError"
        self.thursday = dictionary[FBContact.thursday] as? String ?? "thursdayError"
        self.friday = dictionary[FBContact.friday] as? String ?? "fridayError"
    }
    
    init() {
        self.name = ""
        self.title = ""
        self.office = ""
        self.phone = ""
        self.email = ""
        self.order = 0
        self.image = .logo
        self.monday = ""
        self.tuesday = ""
        self.wednesday = ""
        self.thursday = ""
        self.friday = ""
    }
    
    var tableItems: [DataTableItem] {
        var items: [DataTableItem] = []
        items.append(DataTableItem(headerTitle: FBContact.name, itemTitle: self.name))
        items.append(DataTableItem(headerTitle: FBContact.title, itemTitle: self.title))
        items.append(DataTableItem(headerTitle: FBContact.office, itemTitle: self.office))
        items.append(DataTableItem(headerTitle: FBContact.phone, itemTitle: self.phone))
        items.append(DataTableItem(headerTitle: FBContact.email, itemTitle: self.email))
        items.append(DataTableItem(headerTitle: FBContact.order, itemTitle: String(self.order)))
        return items
    }
}
