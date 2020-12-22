//
//  Enums.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import UIKit

enum SEESData {
    case students, majors, events, contacts
}

enum SEESError: Error {
    case unableToFetchData, unableToFetchStudents, unableToFetchMajors, unableToFetchEvents, unableToFetchContacts
    case unableToValidate(error: String)
    case unableToUpdateData(error: String)
    
    var info: (title: String, message: String) {
        switch self {
        case .unableToFetchData: return ("Unable to Fetch Data", "Please ensure that there is an internent connection or try restarting the app.")
        case .unableToFetchStudents: return ("Unable to Fetch Students", "Please ensure that there is an internent connection or try restarting the app.")
        case .unableToFetchMajors: return ("Unable to Fetch Majors", "Please ensure that there is an internent connection or try restarting the app.")
        case .unableToFetchEvents: return ("Unable to Fetch Events", "Please ensure that there is an internent connection or try restarting the app.")
        case .unableToFetchContacts: return ("Unable to Fetch Contacts", "Please ensure that there is an internent connection or try restarting the app.")
        case .unableToValidate(let error): return ("Unable to Validate Input", "One or more errors occurred: \(error)")
        case .unableToUpdateData(let error): return ("Unable to Update", "An error occurred while trying to update. Please make there is an internet connection. \n\n\(error)")
        }
    }
}

enum FBUser {
    static let advisor = "advisor"
    static let advisorOffice = "advisorOffice"
    static let broncoID = "broncoID"
    static let email = "email"
    static let firstName = "firstName"
    static let lastName = "lastName"
}

enum FBMajor {
    static let majorName = "majorName"
    static let optionName = "optionName"
    static let curriculumSheet = "curriculumSheet"
    static let flowchart = "flowchart"
    static let roadMap = "roadMap"
}

enum FBEvent {
    static let eventName = "eventName"
    static let startDate = "startDate"
    static let endDate = "endDate"
    static let locationName = "locationName"
    static let locationAddress = "locationAddress"
    static let locationCity = "locationCity"
    static let locationState = "locationState"
    static let locationZIP = "locationZIP"
    static let locationCountry = "locationCountry"
    static let notes = "notes"
}

enum FBContact {
    static let name = "name"
    static let title = "title"
    static let office = "office"
    static let phone = "phone"
    static let email = "email"
    static let order = "order"
    static let monday = "monday"
    static let tuesday = "tuesday"
    static let wednesday = "wednesday"
    static let thursday = "thursday"
    static let friday = "friday"
}

enum FirebaseValue: Hashable {
    static let users = "users", majors = "majors", events = "events", contacts = "contacts"
}

enum Symbol {
    static let home = UIImage(systemName: "house.fill")!
    static let calendar = UIImage(systemName: "calendar")!
    static let envelope = UIImage(systemName: "envelope.fill")!
    static let refresh = UIImage(systemName: "arrow.clockwise")!
    static let phone = UIImage(systemName: "phone.fill")!
}

enum ContactImage {
    case logo
    case alas
    case dora
}

enum Validations {
    case studentEmail, broncoID
    
    var regex: String {
        switch self {
        case .studentEmail: return "^[a-zA-Z0-9]+@cpp.edu$"
        case .broncoID: return "^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$"
        }
    }
    
    var error: String {
        switch self {
        case .studentEmail: return "\n\nEnsure the email only contains letters and numbers and uses \"@cpp.edu\"."
        case .broncoID: return "\n\nEnsure the Bronco ID is only digits and is 9 digits long."
        }
    }
}
