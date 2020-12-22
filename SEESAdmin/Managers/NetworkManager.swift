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
    
    func fetchData(completed: @escaping (Result<[SEESData: [DataProtocol]], SEESError>) -> Void) {
        self.reference.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let self = self else { return }
            guard let data = snapshot.value as? [String: Any],
                  let studentsDictionary = data[FirebaseValue.users] as? [String: Any],
                  let majorsDictionary = data[FirebaseValue.majors] as? [String: Any],
                  let eventsDictionary = data[FirebaseValue.events] as? [String: Any],
                  let contactsDictionary = data[FirebaseValue.contacts] as? [String: Any]
            else { completed(.failure(.unableToFetchData)); return }
            
            let studentData: [Student] = self.decode(dictionary: studentsDictionary),
                majorData: [Major] = self.decode(dictionary: majorsDictionary),
                eventData: [Event] = self.decode(dictionary: eventsDictionary),
                contactData: [Contact] = self.decode(dictionary: contactsDictionary)
            
            let dataDictionary: [SEESData: [DataProtocol]] = [
                .students: studentData,
                .majors: majorData,
                .events: eventData,
                .contacts: contactData
            ]
            
            completed(.success(dataDictionary))
        }
    }
    
    private func decode<T: DataProtocol>(dictionary: [String: Any]) -> [T] {
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
