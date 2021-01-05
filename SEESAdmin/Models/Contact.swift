//
//  Contact.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import Foundation

struct Contact: DataProtocol, Hashable {
    let id: String
    let dataCase: SEESData = .contacts
    var path: String {
        return "/\(FirebaseValue.contacts)/\(self.name)"
    }
    var header: String {
        return "contacts"
    }
    var row: String {
        return self.name
    }
    
    var name: String = ""
    var title: String = ""
    var office: String = ""
    var phone: String = ""
    var email: String = ""
    var order: Int = 0
//    var image: ContactImage
//    let notes: String
    
    var monday: String = ""
    var tuesday: String = ""
    var wednesday: String = ""
    var thursday: String = ""
    var friday: String = ""
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        setFBAttributes(with: dictionary)
    }
    
    init() {
        self.id = UUID().uuidString
    }
    
    var detailItems: [DetailTableItem] {
        var items: [DetailTableItem] = []
        items.append(DetailTableItem(header: FBContact.name, row: self.name))
        items.append(DetailTableItem(header: FBContact.title, row: self.title))
        items.append(DetailTableItem(header: FBContact.office, row: self.office))
        items.append(DetailTableItem(header: FBContact.phone, row: self.phone))
        items.append(DetailTableItem(header: FBContact.email, row: self.email))
        items.append(DetailTableItem(header: FBContact.order, row: String(self.order)))
        return items
    }
    
    mutating func setFBAttributes(with dictionary: [String : Any]) {
        self.name = dictionary[FBContact.name] as? String ?? "nameError"
        self.title = dictionary[FBContact.title] as? String ?? "titleError"
        self.office = dictionary[FBContact.office] as? String ?? "officeError"
        self.phone = dictionary[FBContact.phone] as? String ?? "phoneError"
        self.email = dictionary[FBContact.email] as? String ?? "emailError"
        self.order = dictionary[FBContact.order] as? Int ?? -1
//        self.image = self.name.lowercased().contains("alas") ? .alas : .dora
        
        self.monday = dictionary[FBContact.monday] as? String ?? "mondayError"
        self.tuesday = dictionary[FBContact.tuesday] as? String ?? "tuesdayError"
        self.wednesday = dictionary[FBContact.wednesday] as? String ?? "wednesdayError"
        self.thursday = dictionary[FBContact.thursday] as? String ?? "thursdayError"
        self.friday = dictionary[FBContact.friday] as? String ?? "fridayError"
    }
}

extension Contact: Comparable {
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.name < rhs.name
    }
}
