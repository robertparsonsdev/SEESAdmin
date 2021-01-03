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
    var listHeader: String {
        if let letter = self.lastName.first {
            return String(letter)
        } else {
            return "error"
        }
    }
    var listTitle: String {
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
        items.append(DetailTableItem(headerTitle: FBStudent.advisor, itemTitle: self.advisor))
        items.append(DetailTableItem(headerTitle: FBStudent.advisorOffice, itemTitle: self.advisorOffice))
        items.append(DetailTableItem(headerTitle: FBStudent.broncoID, itemTitle: self.broncoID))
        items.append(DetailTableItem(headerTitle: FBStudent.email, itemTitle: self.email))
        items.append(DetailTableItem(headerTitle: FBStudent.firstName, itemTitle: self.firstName))
        items.append(DetailTableItem(headerTitle: FBStudent.lastName, itemTitle: self.lastName))
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

protocol DataProtocol {
    init()
    init(id: String, dictionary: [String: Any])
    
    var id: String { get }
    var dataCase: SEESData { get }
    var path: String { get }
    
    var listHeader: String { get }
    var listTitle: String { get }
//    var listSort: Comparable { get }
    var detailItems: [DetailTableItem] { get }
    
//    var dataDictionary: [String: Any] { get }
    mutating func setFBAttributes(with dictionary: [String: Any])
}

struct DetailTableItem {
    let headerTitle: String
    let itemTitle: String
    var editableView: EditableViewType = .textField
}

enum EditableViewType {
    case textField, datePicker
}
