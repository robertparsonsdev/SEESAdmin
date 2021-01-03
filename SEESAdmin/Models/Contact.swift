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
    var listHeader: String {
        return "contacts"
    }
    var listTitle: String {
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
        items.append(DetailTableItem(headerTitle: FBContact.name, itemTitle: self.name))
        items.append(DetailTableItem(headerTitle: FBContact.title, itemTitle: self.title))
        items.append(DetailTableItem(headerTitle: FBContact.office, itemTitle: self.office))
        items.append(DetailTableItem(headerTitle: FBContact.phone, itemTitle: self.phone))
        items.append(DetailTableItem(headerTitle: FBContact.email, itemTitle: self.email))
        items.append(DetailTableItem(headerTitle: FBContact.order, itemTitle: String(self.order)))
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
