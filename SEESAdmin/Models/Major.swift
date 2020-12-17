//
//  Major.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import Foundation

struct Option: DataProtocol, Hashable {
    let optionName: String
    let curriculumSheet: String
    let flowchart: String
    let roadMap: String
    
    init(dictionary: [String: Any]) {
        self.optionName = dictionary[FBMajor.optionName] as? String ?? "optionNameError"
        self.curriculumSheet = dictionary[FBMajor.curriculumSheet] as? String ?? "curriculumSheetError"
        self.flowchart = dictionary[FBMajor.flowchart] as? String ?? "flowchartError"
        self.roadMap = dictionary[FBMajor.roadMap] as? String ?? "roadMapError"
    }
    
    init() {
        self.optionName = ""
        self.curriculumSheet = ""
        self.flowchart = ""
        self.roadMap = ""
    }
    
    var tableItems: [DataTableItem] {
        var items: [DataTableItem] = []
        items.append(DataTableItem(section: FBMajor.optionName, value: self.optionName))
        items.append(DataTableItem(section: FBMajor.curriculumSheet, value: self.curriculumSheet))
        items.append(DataTableItem(section: FBMajor.flowchart, value: self.flowchart))
        items.append(DataTableItem(section: FBMajor.roadMap, value: self.roadMap))
        return items
    }
}

struct Major: DataProtocol, Hashable {
    let majorName: String
    var options: [Option] = []

    init(dictionary: [String : Any]) {
        self.majorName = dictionary[FBMajor.majorName] as? String ?? "majorNameError"
        
        for(_, value) in dictionary {
            if let optionsDictionary = value as? [String: Any] {
                options.append(Option(dictionary: optionsDictionary))
            }
        }
    }
    
    init() {
        self.majorName = ""
    }
    
    var tableItems: [DataTableItem] {
        return []
    }
    
}
