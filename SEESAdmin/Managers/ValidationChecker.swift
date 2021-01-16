//
//  ValidationManager.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/18/20.
//

import Foundation

struct ValidationChecker {
    static func validateValues(of dictionary: [String: Any], for data: FBDataType) -> SEESError? {
        switch data {
        case .students: return validateStudentData(with: dictionary)
        case .options: return validateOptionData(with: dictionary)
        case .events: return validateEventData(with: dictionary)
        case .contacts: return nil
        }
    }
    
    private static func validateStudentData(with dictionary: [String: Any]) -> SEESError? {
        var errorString: String = ""
        let dataType = FBStudent.self
        
        for data in dataType.allCases {
            let key = data.key, value = dictionary[key] as! String
            
            switch key {
            case dataType.firstName.key, dataType.lastName.key:
                if value.isEmpty {
                    errorString.append("\n\nEnsure the student has a first and last name.")
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
    
    private static func validateOptionData(with dictionary: [String: Any]) -> SEESError? {
        var errorString: String = ""
        let dataType = FBOption.self
        
        for data in dataType.allCases {
            let key = data.key, value = dictionary[key] as! String
            
            switch key {
            case dataType.majorName.key, dataType.optionName.key:
                if value.isEmpty {
                    errorString.append("\n\nEnsure there is a major name and an option name.")
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
    
    private static func validateEventData(with dictionary: [String: Any]) -> SEESError? {
        var errorString: String = ""
        let dataType = FBEvent.self
        let address = dataType.locationAddress.key, city = dataType.locationCity.key, state = dataType.locationState.key, zip = dataType.locationZIP.key, country = dataType.locationCountry.key
        let addressComponents = [dictionary[address] as! String, dictionary[city] as! String, dictionary[state] as! String, dictionary[zip] as! String, dictionary[country] as! String]
        var incompleteAddress: Bool = false
        
        for data in dataType.allCases {
            let key = data.key, value = dictionary[key] as! String
            
            switch key {
            case dataType.eventName.key:
                if value.isEmpty {
                    errorString.append("\n\nEnsure there is an event name.")
                }
            case dataType.date.key:
                if value.isEmpty {
                    errorString.append("\n\nEnsure there is a date.")
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
}

enum Validations {
    case email, broncoID
    case link
    
    var regex: String {
        switch self {
        case .email: return "^[a-zA-Z0-9]+@cpp.edu$"
        case .broncoID: return "^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$"
        case .link: return "^https://www.cpp.edu"
        }
    }
    
    var error: String {
        switch self {
        case .email: return "\n\nEnsure the email only contains letters and numbers and uses \"@cpp.edu\"."
        case .broncoID: return "\n\nEnsure the Bronco ID is only digits and is 9 digits long."
        case .link: return "\n\nEnsure all three of the links are CPP links with this format: \n\"https://www.cpp.edu/...\""
        }
    }
}
