//
//  Event.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import Foundation

struct Event: DataProtocol, Hashable {
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
        if let startDate = dictionary[FBEvent.startDate] as? String {
            self.startDate = startDate.convertToDate() ?? Date()
        } else {
            self.startDate = Date()
        }
        
        if let endDate = dictionary[FBEvent.endDate] as? String {
            self.endDate = endDate.convertToDate() ?? Date()
        } else {
            self.endDate = Date()
        }
        
        self.eventName = dictionary[FBEvent.eventName] as? String ?? "eventNameError"
        self.locationName = dictionary[FBEvent.locationName] as? String ?? "locationNameError"
        self.locationAddress = dictionary[FBEvent.locationAddress] as? String ?? "locationAddressError"
        self.locationCity = dictionary[FBEvent.locationCity] as? String ?? "locationCityError"
        self.locationState = dictionary[FBEvent.locationState] as? String ?? "locationStateError"
        self.locationZIP = dictionary[FBEvent.locationZIP] as? Int ?? -1
        self.locationCountry = dictionary[FBEvent.locationCountry] as? String ?? "locationCountryError"
        self.notes = dictionary[FBEvent.notes] as? String ?? "notesError"
    }
    
    var tableItems: [DataTableItem] {
        var items: [DataTableItem] = []
        items.append(DataTableItem(section: FBEvent.startDate, value: self.startDate.convertToString()))
        items.append(DataTableItem(section: FBEvent.endDate, value: self.endDate.convertToString()))
        items.append(DataTableItem(section: FBEvent.eventName, value: self.eventName))
        items.append(DataTableItem(section: FBEvent.locationName, value: self.locationName))
        items.append(DataTableItem(section: FBEvent.locationAddress, value: self.locationAddress))
        items.append(DataTableItem(section: FBEvent.locationCity, value: self.locationCity))
        items.append(DataTableItem(section: FBEvent.locationState, value: self.locationState))
        items.append(DataTableItem(section: FBEvent.locationZIP, value: String(self.locationZIP)))
        items.append(DataTableItem(section: FBEvent.locationCountry, value: self.locationCountry))
        items.append(DataTableItem(section: FBEvent.notes, value: self.notes))
        return items
    }
}
