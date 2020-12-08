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
    
    private init() { }
    
    func fetchData(completed: @escaping (Result<[SEESData: [DataProtocol]], SEESError>) -> Void) {
        Database.database().reference().observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let self = self else { return }
            guard let data = snapshot.value as? [String: Any],
                  let studentsDictionary = data[FirebaseValue.users] as? [String: Any],
                  let majorsDictionary = data[FirebaseValue.majors] as? [String: Any],
                  let eventsDictionary = data[FirebaseValue.events] as? [String: Any],
                  let contactsDictionary = data [FirebaseValue.contacts] as? [String: Any]
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
        for (_, value) in dictionary {
            data.append(T(dictionary: value as! [String: Any]))
        }
        
        return data
    }
    
    func fetchStudents(completed: @escaping (Result<[Student], SEESError>) -> Void) {
        Database.database().reference().child(FirebaseValue.users).observeSingleEvent(of: .value) { (snapshot) in
            guard let studentsDictionary = snapshot.value as? [String: [String: Any]] else { completed(.failure(.unableToFetchStudents)); return }
            var students: [Student] = []
            for (_, value) in studentsDictionary {
                students.append(Student(dictionary: value))
            }
            
            completed(.success(students))
        }
    }
    
    func fetchMajors(completed: @escaping (Result<[Major], SEESError>) -> Void) {
        
    }
    
    func fetchEvents(completed: @escaping (Result<[Event], SEESError>) -> Void) {
        
    }
    
    func fetchContacts(completed: @escaping (Result<[Contact], SEESError>) -> Void) {
        
    }
}
