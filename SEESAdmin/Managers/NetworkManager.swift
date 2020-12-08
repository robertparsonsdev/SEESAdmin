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
    
    func fetchData(completed: @escaping (Result<[SEESData: [Any]], SEESError>) -> Void) {
        Database.database().reference().observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [String: Any],
                  let studentsDictionary = data[FirebaseValue.users] as? [String: [String: Any]],
                  let majorsDictionary = data[FirebaseValue.majors] as? [String: [String: [String: Any]]],
                  let eventsDictionary = data[FirebaseValue.events] as? [String: [String: Any]],
                  let contactsDictionary = data [FirebaseValue.contacts] as? [String: [String: Any]]
            else { completed(.failure(.unableToFetchData)); return }
            
            var dataDictionary: [SEESData: [Any]] = [
                .students: [],
                .majors: [],
                .events: [],
                .contacts: []
            ]
            
            for (_, value) in studentsDictionary {
                dataDictionary[.students]?.append(Student(dictionary: value))
            }
            
            for (_, value) in majorsDictionary {
                dataDictionary[.majors]?.append(Major(dictionary: value))
            }
            
            for (_, value) in eventsDictionary {
                dataDictionary[.events]?.append(Event(dictionary: value))
            }
            
            for (_, value) in contactsDictionary {
                dataDictionary[.contacts]?.append(Contact(dictionary: value))
            }
            
            completed(.success(dataDictionary))
        }
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
