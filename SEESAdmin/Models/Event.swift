//
//  Event.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import Foundation

struct Event: DataProtocol, Hashable {
    let id: String
    let dataCase: SEESData = .events
    var path: String {
        return "/\(FirebaseValue.events)/\(self.eventName)"
    }
    var header: String {
        return "events"
    }
    var row: String {
        return self.eventName
    }
    
    var startDate: Date = Date()
    var endDate: Date = Date()
    var eventName: String = ""
    var locationName: String = ""
    var locationAddress: String = ""
    var locationCity: String = ""
    var locationState: String = ""
    var locationZIP: Int = 0
    var locationCountry: String = ""
    var notes: String = ""
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        setFBAttributes(with: dictionary)
    }
    
    init() {
        self.id = UUID().uuidString
    }
    
    var detailItems: [DetailTableItem] {
        var items: [DetailTableItem] = []
        items.append(DetailTableItem(header: FBEvent.startDate, row: self.startDate.convertToString(), editableView: .datePicker))
        items.append(DetailTableItem(header: FBEvent.endDate, row: self.endDate.convertToString(), editableView: .datePicker))
        items.append(DetailTableItem(header: FBEvent.eventName, row: self.eventName))
        items.append(DetailTableItem(header: FBEvent.locationName, row: self.locationName))
        items.append(DetailTableItem(header: FBEvent.locationAddress, row: self.locationAddress))
        items.append(DetailTableItem(header: FBEvent.locationCity, row: self.locationCity))
        items.append(DetailTableItem(header: FBEvent.locationState, row: self.locationState))
        items.append(DetailTableItem(header: FBEvent.locationZIP, row: String(self.locationZIP)))
        items.append(DetailTableItem(header: FBEvent.locationCountry, row: self.locationCountry))
        items.append(DetailTableItem(header: FBEvent.notes, row: self.notes))
        return items
    }
    
    mutating func setFBAttributes(with dictionary: [String : Any]) {
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
}

extension Event: Comparable {
    static func < (lhs: Event, rhs: Event) -> Bool {
        return lhs.startDate < rhs.startDate
    }
}
