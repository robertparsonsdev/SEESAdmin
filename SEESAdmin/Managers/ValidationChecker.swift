//
//  ValidationManager.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/18/20.
//

import Foundation

struct ValidationChecker {
    static func validateText(of dictionary: [String: Any], for data: FBDataType) -> SEESError? {
        switch data {
        case .students:
            if let error = validateStudentData(with: dictionary) { return .unableToValidate(error: error) }
            else { return nil }
        case .options: return nil
        case .events: return nil
        case .contacts: return nil
        }
    }
    
    private static func validateStudentData(with dictionary: [String: Any]) -> String? {
        var errorString: String = ""
        
        for data in FBStudent.allCases {
            let key = data.key, value = dictionary[key] as! String
            
            switch key {
            case FBStudent.firstName.key, FBStudent.lastName.key:
                if value.isEmpty {
                    errorString.append("\n\nEnsure the student has a first and last name.")
                }
            case FBStudent.email.key:
                if !(value ~= Validations.email.regex) {
                    errorString.append(Validations.email.error)
                }
            case FBStudent.broncoID.key:
                if !(value ~= Validations.broncoID.regex) {
                    errorString.append(Validations.broncoID.error)
                }
            default: break
            }
        }
        
        return errorString.isEmpty ? nil : errorString
    }
}

enum Validations {
    case email, broncoID
    
    var regex: String {
        switch self {
        case .email: return "^[a-zA-Z0-9]+@cpp.edu$"
        case .broncoID: return "^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$"
        }
    }
    
    var error: String {
        switch self {
        case .email: return "\n\nEnsure the email only contains letters and numbers and uses \"@cpp.edu\"."
        case .broncoID: return "\n\nEnsure the Bronco ID is only digits and is 9 digits long."
        }
    }
}
