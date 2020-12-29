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
    
    func fetchData(completed: @escaping (Result<[SEESData: [DataProtocol]], SEESError>) -> Void) {
        self.reference.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let self = self else { return }
            guard let data = snapshot.value as? [String: Any],
                  let studentsDictionary = data[FirebaseValue.students] as? [String: Any],
                  let optionsDictionary = data[FirebaseValue.options] as? [String: Any],
                  let eventsDictionary = data[FirebaseValue.events] as? [String: Any],
                  let contactsDictionary = data[FirebaseValue.contacts] as? [String: Any]
            else { completed(.failure(.unableToFetchData)); return }
            
            let studentData: [Student] = self.decode(studentsDictionary),
                optionData: [Option] = self.decode(optionsDictionary),
                eventData: [Event] = self.decode(eventsDictionary),
                contactData: [Contact] = self.decode(contactsDictionary)
            
            let dataDictionary: [SEESData: [DataProtocol]] = [
                .students: studentData,
                .options: optionData,
                .events: eventData,
                .contacts: contactData
            ]
            
            completed(.success(dataDictionary))
        }
    }
    
    private func decode<T: DataProtocol>(_ dictionary: [String: Any]) -> [T] {
        var data: [T] = []
        for (key, value) in dictionary {
            data.append(T(id: key, dictionary: value as! [String: Any]))
        }
        
        return data
    }
    
    func updateData(at path: String, with values: [String: Any], completed: @escaping (SEESError?) -> Void) {
        self.reference.child(path).updateChildValues(values) { (error, reference) in
            if let error = error {
                completed(.unableToUpdateData(error: error.localizedDescription))
            } else {
                completed(nil)
            }
        }
    }
}
