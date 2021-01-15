//
//  Enums.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import UIKit

enum SEESError: Error {
    case unableToFetchData, unableToFetchStudents, unableToFetchOptions, unableToFetchEvents, unableToFetchContacts
    case unableToValidate(error: String)
    case unableToUpdateData(error: String)
    case unableToAddStudent(error: String), unableToAddData(error: String)
    case unableToReloadList
    
    var info: (title: String, message: String) {
        switch self {
        case .unableToFetchData: return ("Unable to Fetch Data", "Please ensure that there is an internent connection or try restarting the app.")
        case .unableToFetchStudents: return ("Unable to Fetch Students", "Please ensure that there is an internent connection or try restarting the app.")
        case .unableToFetchOptions: return ("Unable to Fetch Options", "Please ensure that there is an internent connection or try restarting the app.")
        case .unableToFetchEvents: return ("Unable to Fetch Events", "Please ensure that there is an internent connection or try restarting the app.")
        case .unableToFetchContacts: return ("Unable to Fetch Contacts", "Please ensure that there is an internent connection or try restarting the app.")
        case .unableToValidate(let error): return ("Unable to Validate Input", "One or more errors occurred: \(error)")
        case .unableToUpdateData(let error): return ("Unable to Update", "An error occurred while trying to update. Please make there is an internet connection or try restarting the app. \n\n\(error)")
        case .unableToAddStudent(let error): return ("Unable to Add Student", "An error ocurred while trying to add a student. Please restart the app. \n\n\(error)")
        case .unableToAddData(let error): return ("Unable to Add Data", "An error ocurred while trying to add this data. Please restart the app. \n\n\(error)")
        case .unableToReloadList: return ("Unable to Reload List", "The updated data was saved in the database, but there was an error showing the new data. Please restart the app.")
        }
    }
}

enum FBDataType: String {
    case students = "students"
    case options = "options"
    case events = "events"
    case contacts = "contacts"
}

protocol FBDataProtocol {
    var key: String { get }
    static var emptyKeys: [String: Any] { get }
}

enum FBStudent: FBDataProtocol, CaseIterable {
    case firstName
    case lastName
    case email
    case broncoID
    case advisor
    case advisorOffice
    
    var key: String {
        switch self {
        case .firstName: return "first-name"
        case .lastName: return "last-name"
        case .email: return "email"
        case .broncoID: return "bronco-id"
        case .advisor: return "advisor"
        case .advisorOffice: return "advisor-office"
        }
    }
    
    static var emptyKeys: [String: Any] {
        var dictionary: [String: Any] = [:]
        for value in Self.allCases {
            dictionary[value.key] = ""
        }
        return dictionary
    }
}

enum FBOption: FBDataProtocol, CaseIterable {
    case majorName
    case optionName
    case curriculumSheet
    case flowchart
    case roadMap
    
    var key: String {
        switch self {
        case .majorName: return "major-name"
        case .optionName: return "option-name"
        case .curriculumSheet: return "curriculum-sheet"
        case .flowchart: return "flowchart"
        case .roadMap: return "road-map"
        }
    }
    
    static var emptyKeys: [String : Any] {
        var dictionary: [String: Any] = [:]
        for value in Self.allCases {
            dictionary[value.key] = ""
        }
        return dictionary
    }
}

enum FBEvent: FBDataProtocol, CaseIterable {
    case eventName
    case startDate
    case endDate
    case locationName
    case locationAddress
    case locationCity
    case locationState
    case locationZIP
    case locationCountry
    case notes
    
    var key: String {
        switch self {
        case .eventName: return "event-name"
        case .startDate: return "start-date"
        case .endDate: return "end-date"
        case .locationName: return "location-name"
        case .locationAddress: return "location-address"
        case .locationCity: return "location-city"
        case .locationState: return "location-state"
        case .locationZIP: return "location-zip"
        case .locationCountry: return "location-country"
        case .notes: return "notes"
        }
    }
    
    static var emptyKeys: [String : Any] {
        var dictionary: [String: Any] = [:]
        for value in Self.allCases {
            dictionary[value.key] = ""
        }
        return dictionary
    }
}

enum FBContact: FBDataProtocol, CaseIterable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case name
    case title
    case office
    case phone
    case email
    case order
    
    var key: String {
        switch self {
        case .monday: return "monday"
        case .tuesday: return "tuesday"
        case .wednesday: return "wednesday"
        case .thursday: return "thursday"
        case .friday: return "friday"
        case .name: return "name"
        case .title: return "title"
        case .office: return "office"
        case .phone: return "phone"
        case .email: return "email"
        case .order: return "order"
        }
    }
    
    static var emptyKeys: [String: Any] {
        var dictionary: [String: Any] = [:]
        for value in Self.allCases {
            dictionary[value.key] = ""
        }
        return dictionary
    }
}

enum FBMajor: String, CaseIterable {
    case biology = "Biology"
    case biotech = "Biotechnology"
    case chem = "Chemistry"
    case cs = "Computer Science"
    case envBio = "Environmental Biology"
    case geo = "Geology"
    case kin = "Kinesiology"
    case math = "Mathematics"
    case phy = "Physics"
}
