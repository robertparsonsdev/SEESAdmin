//
//  Event.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import Foundation

struct Event: DataProtocol {
    let startDate: Date
    let endDate: Date
    let eventName: String
    let locationName: String
    let locationAddress: String
    let locationCity: String
    let locationState: String
    let locationZIP: Int
    let locationCountry: String
    let notes: String
    
    init(dictionary: [String: Any]) {
        if let startDate = dictionary[FirebaseValue.startDate] as? String {
            self.startDate = startDate.convertToDate() ?? Date()
        } else {
            self.startDate = Date()
        }
        
        if let endDate = dictionary[FirebaseValue.endDate] as? String {
            self.endDate = endDate.convertToDate() ?? Date()
        } else {
            self.endDate = Date()
        }
        
        self.eventName = dictionary[FirebaseValue.eventName] as? String ?? "eventNameError"
        self.locationName = dictionary[FirebaseValue.locationName] as? String ?? "locationNameError"
        self.locationAddress = dictionary[FirebaseValue.locationAddress] as? String ?? "locationAddressError"
        self.locationCity = dictionary[FirebaseValue.locationCity] as? String ?? "locationCityError"
        self.locationState = dictionary[FirebaseValue.locationState] as? String ?? "locationStateError"
        self.locationZIP = dictionary[FirebaseValue.locationZIP] as? Int ?? -1
        self.locationCountry = dictionary[FirebaseValue.locationCountry] as? String ?? "locationCountryError"
        self.notes = dictionary[FirebaseValue.notes] as? String ?? "notesError"
    }
}
