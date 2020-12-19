//
//  ValidationManager.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/18/20.
//

import Foundation

class ValidationManager {
    static let shared = ValidationManager()

    private init() { }
    
    func validateText(of dictionary: [String: Any], for data: SEESData, completed: @escaping (Result<DataProtocol, SEESError>) -> Void) {
        switch data {
        case .students:
            if let error = validateStudentData(with: dictionary) { completed(.failure(.unableToValidate(error: error))) }
            else { completed(.success(Student(dictionary: dictionary))) }
        case .majors: print("majors")
        case .events: print("events")
        case .contacts: print("contacts")
        }
    }
    
    private func validateStudentData(with dictionary: [String: Any]) -> String? {
        var errorString: String = ""
        for (key, value) in dictionary {
            let string = value as! String
            switch key {
            case FBUser.email:
                if !(string ~= Validations.studentEmail.regex) {
                    errorString.append(Validations.studentEmail.error)
                }
            case FBUser.broncoID:
                if !(string ~= Validations.broncoID.regex) {
                    errorString.append(Validations.broncoID.error)
                }
            default: break
            }
        }
        
        return errorString.isEmpty ? nil : errorString
    }
}
