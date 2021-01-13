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
        for (key, value) in dictionary {
            let string = value as! String
            switch key {
            case FBStudent.email.key:
                if !(string ~= Validations.studentEmail.regex) {
                    errorString.append(Validations.studentEmail.error)
                }
            case FBStudent.broncoID.key:
                if !(string ~= Validations.broncoID.regex) {
                    errorString.append(Validations.broncoID.error)
                }
            default: break
            }
        }
        
        return errorString.isEmpty ? nil : errorString
    }
}
