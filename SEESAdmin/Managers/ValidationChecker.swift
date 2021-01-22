//
//  ValidationManager.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/18/20.
//

import Foundation

struct ValidationChecker {
    static func validateValues(of dictionary: [String: String], for data: FBDataType) -> SEESError? {
        switch data {
        case .students: return validateStudentData(with: dictionary)
        case .options: return validateOptionData(with: dictionary)
        case .events: return validateEventData(with: dictionary)
        case .contacts: return validateContactData(with: dictionary)
        }
    }
    
    private static func validateStudentData(with dictionary: [String: String]) -> SEESError? {
        var errorString: String = ""
        let dataType = FBStudent.self
        
        for data in dataType.allCases {
            let key = data.key, value = dictionary[key]!
            
            switch key {
            case dataType.firstName.key, dataType.lastName.key:
                if value.isEmpty {
                    errorString.append("\n\nEnsure the student has a \(key).")
                }
            case dataType.email.key:
                if !(value ~= Validations.email.regex) {
                    errorString.append(Validations.email.error)
                }
            case dataType.broncoID.key:
                if !(value ~= Validations.broncoID.regex) {
                    errorString.append(Validations.broncoID.error)
                }
            default: break
            }
        }
        
        return errorString.isEmpty ? nil : .unableToValidate(error: errorString)
    }
    
    private static func validateOptionData(with dictionary: [String: String]) -> SEESError? {
        var errorString: String = ""
        let dataType = FBOption.self
        
        for data in dataType.allCases {
            let key = data.key, value = dictionary[key]!
            
            switch key {
            case dataType.majorName.key, dataType.optionName.key:
                if value.isEmpty {
                    errorString.append("\n\nEnsure \(key) has a value.")
                }
            case dataType.curriculumSheet.key, dataType.flowchart.key, dataType.roadMap.key:
                if !(value ~= Validations.link.regex) {
                    errorString.append(Validations.link.error)
                }
            default: break
            }
        }
        
        return errorString.isEmpty ? nil : .unableToValidate(error: errorString)
    }
    
    private static func validateEventData(with dictionary: [String: String]) -> SEESError? {
        var errorString: String = ""
        let dataType = FBEvent.self
        let address = dataType.locationAddress.key, city = dataType.locationCity.key, state = dataType.locationState.key, zip = dataType.locationZIP.key, country = dataType.locationCountry.key
        let addressComponents = [dictionary[address]!, dictionary[city]!, dictionary[state]!, dictionary[zip]!, dictionary[country]!]
        var incompleteAddress: Bool = false
        
        for data in dataType.allCases {
            let key = data.key, value = dictionary[key]!
            
            switch key {
            case dataType.eventName.key, dataType.date.key:
                if value.isEmpty {
                    errorString.append("\n\nEnsure \(key) has a value.")
                }
            case address, city, state, zip, country:
                guard !incompleteAddress else { break }
                if !value.isEmpty {
                    for component in addressComponents {
                        if component.isEmpty {
                            incompleteAddress = true
                            errorString.append("\n\nPlease ensure a complete address is entered.")
                            break
                        }
                    }
                } else {
                    break
                }
            default: break
            }
        }
        
        return errorString.isEmpty ? nil : .unableToValidate(error: errorString)
    }
    
    private static func validateContactData(with dictionary: [String: String]) -> SEESError? {
        var errorString: String = ""
        let dataType = FBContact.self
        
        for data in dataType.allCases {
            let key = data.key, value = dictionary[key]!
            
            switch key {
            case dataType.fullName.key, dataType.title.key, dataType.office.key:
                if value.isEmpty {
                    errorString.append("\n\nEnsure \(key) contains a value.")
                }
            case dataType.phone.key:
                if !(value ~= Validations.phone.regex) {
                    errorString.append(Validations.phone.error)
                }
            case dataType.email.key:
                if !(value ~= Validations.email.regex) {
                    errorString.append(Validations.email.error)
                }
            case dataType.order.key:
                if !(value ~= Validations.order.regex) {
                    errorString.append(Validations.order.error)
                }
            case dataType.monday.key, dataType.tuesday.key, dataType.wednesday.key, dataType.thursday.key, dataType.friday.key:
                guard !value.isEmpty else { break }
                let times = value.components(separatedBy: "-")
                if let startTime = times.getItemAt(0)?.converToTime(), let endTime = times.getItemAt(1)?.converToTime() {
                    if startTime > endTime {
                        errorString.append("\n\nEnsure that \(key)'s start time is before it's end time.")
                    }
                }
            default: break
            }
        }
        
        return errorString.isEmpty ? nil : .unableToValidate(error: errorString)
    }
}

enum Validations {
    case email, broncoID
    case link
    case phone, order
    
    var regex: String {
        switch self {
        case .email: return "^[a-zA-Z0-9]+@cpp.edu$"
        case .broncoID: return "^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$"
        case .link: return "^https://www.cpp.edu"
        case .phone: return "^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$"
        case .order: return "^[0-9]+$"
        }
    }
    
    var error: String {
        switch self {
        case .email: return "\n\nEnsure the email only contains letters and numbers and uses \"@cpp.edu\"."
        case .broncoID: return "\n\nEnsure the Bronco ID is only digits and is 9 digits long."
        case .link: return "\n\nEnsure all three of the links are CPP links with this format: \n\"https://www.cpp.edu/...\""
        case .phone: return "\n\nEnsure the phone number is 10 digits long and doesn't contain any special characters."
        case .order: return "\n\nEnsure the order is a unique, positive integer."
        }
    }
}
