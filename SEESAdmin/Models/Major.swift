//
//  Major.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import Foundation

struct Option: DataProtocol {
    let optionName: String
    let curriculumSheet: String
    let flowchart: String
    let roadMap: String
    
    init(dictionary: [String: Any]) {
        self.optionName = dictionary[FirebaseValue.optionName] as? String ?? "optionNameError"
        self.curriculumSheet = dictionary[FirebaseValue.curriculumSheet] as? String ?? "curriculumSheetError"
        self.flowchart = dictionary[FirebaseValue.flowchart] as? String ?? "flowchartError"
        self.roadMap = dictionary[FirebaseValue.roadMap] as? String ?? "roadMapError"    }
}

struct Major: DataProtocol {
    var options: [Option] = []

    init(dictionary: [String : Any]) {
        for(_, value) in dictionary {
            options.append(Option(dictionary: value as! [String: Any]))
        }
    }
}
