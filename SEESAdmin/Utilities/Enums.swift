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
    
    var info: (title: String, message: String) {
        switch self {
        case .unableToFetchData: return ("Unable to Fetch Data", "Please ensure that there is an internent connection or try restarting the app.")
        case .unableToFetchStudents: return ("Unable to Fetch Students", "Please ensure that there is an internent connection or try restarting the app.")
        case .unableToFetchMajors: return ("Unable to Fetch Majors", "Please ensure that there is an internent connection or try restarting the app.")
        case .unableToFetchEvents: return ("Unable to Fetch Events", "Please ensure that there is an internent connection or try restarting the app.")
        case .unableToFetchContacts: return ("Unable to Fetch Contacts", "Please ensure that there is an internent connection or try restarting the app.")
        }
    }
}

enum MajorInfo {
    case academicAdvising, biology, biotechnology, chemistry, computerScience, environmentalBiology, geology, kinesiology, mathematics, physics
    
    var name: String {
        switch self {
        case .academicAdvising: return "Academic Advising"
        case .biology: return "Biology"
        case .biotechnology: return "Biotechnology"
        case .chemistry: return "Chemistry"
        case .computerScience: return "Computer Science"
        case .environmentalBiology: return "Environmental Biology"
        case .geology: return "Geology"
        case .kinesiology: return "Kinesiology"
        case .mathematics: return "Mathematics"
        case .physics: return "Physics"
        }
    }
    
    var image: UIImage {
        switch self {
        case .academicAdvising: return UIImage(named: "checkmark")!
        case .biology: return UIImage(named: "bio")!
        case .biotechnology: return UIImage(named: "biotech")!
        case .chemistry: return UIImage(named: "chem")!
        case .computerScience: return UIImage(named: "cs")!
        case .environmentalBiology: return UIImage(named: "env-bio")!
        case .geology: return UIImage(named: "geo")!
        case .kinesiology: return UIImage(named: "kin")!
        case .mathematics: return UIImage(named: "math")!
        case .physics: return UIImage(named: "phy")!
        }
    }
    
    var firebaseValue: String {
        switch self {
        case .academicAdvising: return ""
        case .biology: return FirebaseValue.biology
        case .biotechnology: return FirebaseValue.biotechnology
        case .chemistry: return FirebaseValue.chemistry
        case .computerScience: return FirebaseValue.computerScience
        case .environmentalBiology: return FirebaseValue.environmentalBiology
        case .geology: return FirebaseValue.geology
        case .kinesiology: return FirebaseValue.kinesiology
        case .mathematics: return FirebaseValue.mathematics
        case .physics: return FirebaseValue.physics
        }
    }
}

enum FirebaseValue: Hashable {
    static let users = "users", majors = "majors", events = "events", contacts = "contacts"
    
    static let advisor = "advisor"
    static let advisorOffice = "advisorOffice"
    static let broncoID = "broncoID"
    static let email = "email"
    static let firstName = "firstName"
    static let lastName = "lastName"
    
    static let biology = "biology"
    static let biotechnology = "biotechnology"
    static let chemistry = "chemistry"
    static let computerScience = "computerScience"
    static let environmentalBiology = "environmentalBiology"
    static let geology = "geology"
    static let kinesiology = "kinesiology"
    static let mathematics = "mathematics"
    static let physics = "physics"
    
    static let optionName = "optionName"
    static let curriculumSheet = "curriculumSheet"
    static let flowchart = "flowchart"
    static let roadMap = "roadMap"
    
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
    
    static let name = "name"
    static let title = "title"
    static let office = "office"
    static let phone = "phone"
    static let order = "order"
    static let monday = "monday"
    static let tuesday = "tuesday"
    static let wednesday = "wednesday"
    static let thursday = "thursday"
    static let friday = "friday"
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
