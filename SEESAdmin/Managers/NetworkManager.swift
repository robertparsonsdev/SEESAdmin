//
//  NetworkManager.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import Foundation
import Firebase

class NetworkManager {
    static let shared = NetworkManager()
    private let reference = Database.database().reference()
    
    private init() { }
    
    func signIn() {
        Auth.auth().signIn(withEmail: "sees@cpp.edu", password: "463849276") { (result, error) in
            print("signed in")
        }
    }
    
    func fetchData(completed: @escaping (Result<[FBDataType: [DataModel]], SEESError>) -> Void) {
        self.reference.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let self = self else { return }
            guard let data = snapshot.value as? [String: Any],
                  let studentsDictionary = data[FBDataType.students.rawValue] as? [String: Any],
                  let optionsDictionary = data[FBDataType.options.rawValue] as? [String: Any],
                  let eventsDictionary = data[FBDataType.events.rawValue] as? [String: Any],
                  let contactsDictionary = data[FBDataType.contacts.rawValue] as? [String: Any]
            else { completed(.failure(.unableToFetchData)); return }
            
            let dataDictionary: [FBDataType: [DataModel]] = [
                .students: self.decode(studentsDictionary, for: .students),
                .options: self.decode(optionsDictionary, for: .options),
                .events: self.decode(eventsDictionary, for: .events),
                .contacts: self.decode(contactsDictionary, for: .contacts)
            ]
            
            completed(.success(dataDictionary))
        }
    }
    
    private func decode(_ dictionary: [String: Any], for type: FBDataType) -> [DataModel] {
        var data: [DataModel] = []
        for (key, value) in dictionary {
            data.append(DataModel(id: key, data: value as! [String: Any], type: type))
        }
        
        return data
    }
    
    func updateData(at path: String, with dictionary: [String: Any], completed: @escaping (SEESError?) -> Void) {
        self.reference.child(path).updateChildValues(dictionary) { (error, reference) in
            guard error == nil else { completed(.unableToUpdateData(error: error!.localizedDescription)); return }
            
            completed(nil)
        }
    }
    
    func add(at path: String, with dictionary: [String: Any], completed: @escaping (SEESError?) -> Void) {
        updateData(at: path, with: dictionary) { (error) in
            completed(error)
        }
    }
    
    func createUser(withEmail email: String, andPassword password: String, completed: @escaping (Result<String, SEESError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard error == nil else { completed(.failure(.unableToAddStudent(error: error!.localizedDescription))); return }
            
            if let id = result?.user.uid {
                completed(.success(id))
            } else {
                completed(.failure(.unableToAddStudent(error: "")))
            }
        }
    }
}
