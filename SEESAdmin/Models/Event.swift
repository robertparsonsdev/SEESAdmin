//
//  Event.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import Foundation

struct Event: DataProtocol, Hashable {
    let dataCase: SEESData = .events
    
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
            self.startDate = startDate.convertToDate()
        } else {
            self.startDate = Date()
        }
        
        if let endDate = dictionary[FBEvent.endDate] as? String {
            self.endDate = endDate.convertToDate()
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
    
    init() {
        self.startDate = Date()
        self.endDate = Date()
        self.eventName = ""
        self.locationName = ""
        self.locationAddress = ""
        self.locationCity = ""
        self.locationState = ""
        self.locationZIP = 0
        self.locationCountry = ""
        self.notes = ""
    }
    
    var tableItems: [DataTableItem] {
        var items: [DataTableItem] = []
        items.append(DataTableItem(headerTitle: FBEvent.startDate, itemTitle: self.startDate.convertToString(), editableView: .datePicker))
        items.append(DataTableItem(headerTitle: FBEvent.endDate, itemTitle: self.endDate.convertToString(), editableView: .datePicker))
        items.append(DataTableItem(headerTitle: FBEvent.eventName, itemTitle: self.eventName))
        items.append(DataTableItem(headerTitle: FBEvent.locationName, itemTitle: self.locationName))
        items.append(DataTableItem(headerTitle: FBEvent.locationAddress, itemTitle: self.locationAddress))
        items.append(DataTableItem(headerTitle: FBEvent.locationCity, itemTitle: self.locationCity))
        items.append(DataTableItem(headerTitle: FBEvent.locationState, itemTitle: self.locationState))
        items.append(DataTableItem(headerTitle: FBEvent.locationZIP, itemTitle: String(self.locationZIP)))
        items.append(DataTableItem(headerTitle: FBEvent.locationCountry, itemTitle: self.locationCountry))
        items.append(DataTableItem(headerTitle: FBEvent.notes, itemTitle: self.notes))
        return items
    }
}
