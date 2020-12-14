//
//  Contact.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import Foundation

struct Contact: DataProtocol, Hashable {
    let name: String
    let title: String
    let office: String
    let phone: String
    let email: String
    let order: Int
    let image: ContactImage
//    let notes: String
    
    let monday: String
    let tuesday: String
    let wednesday: String
    let thursday: String
    let friday: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary[FirebaseValue.name] as? String ?? "nameError"
        self.title = dictionary[FirebaseValue.title] as? String ?? "titleError"
        self.office = dictionary[FirebaseValue.office] as? String ?? "officeError"
        self.phone = dictionary[FirebaseValue.phone] as? String ?? "phoneError"
        self.email = dictionary[FirebaseValue.email] as? String ?? "emailError"
        self.order = dictionary[FirebaseValue.order] as? Int ?? -1
        self.image = self.name.lowercased().contains("alas") ? .alas : .dora
        
        self.monday = dictionary[FirebaseValue.monday] as? String ?? "mondayError"
        self.tuesday = dictionary[FirebaseValue.tuesday] as? String ?? "tuesdayError"
        self.wednesday = dictionary[FirebaseValue.wednesday] as? String ?? "wednesdayError"
        self.thursday = dictionary[FirebaseValue.thursday] as? String ?? "thursdayError"
        self.friday = dictionary[FirebaseValue.friday] as? String ?? "fridayError"
    }
}
