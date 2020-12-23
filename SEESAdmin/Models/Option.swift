//
//  Option.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/7/20.
//

import Foundation

struct Option: DataProtocol, Hashable {
    var id: String
    var dataCase: SEESData = .options
    var path: String {
        return "/\(FirebaseValue.options)/\(self.id)"
    }
    
    let optionName: String
    let majorName: String
    let curriculumSheet: String
    let flowchart: String
    let roadMap: String
    
    init(id: String, dictionary: [String : Any]) {
        self.id = id
        self.optionName = dictionary[FBOption.optionName] as? String ?? "optionNameError"
        self.majorName = dictionary[FBOption.majorName] as? String ?? "majorNameError"
        self.curriculumSheet = dictionary[FBOption.curriculumSheet] as? String ?? "curriculumSheetError"
        self.flowchart = dictionary[FBOption.flowchart] as? String ?? "flowchartError"
        self.roadMap = dictionary[FBOption.roadMap] as? String ?? "roadMapError"
    }
    
    init() {
        self.id = UUID().uuidString
        self.optionName = ""
        self.majorName = ""
        self.curriculumSheet = ""
        self.flowchart = ""
        self.roadMap = ""
    }
    
    var tableItems: [DataTableItem] {
        var items: [DataTableItem] = []
        items.append(DataTableItem(headerTitle: FBOption.optionName, itemTitle: self.optionName))
        items.append(DataTableItem(headerTitle: FBOption.majorName, itemTitle: self.majorName))
        items.append(DataTableItem(headerTitle: FBOption.curriculumSheet, itemTitle: self.curriculumSheet))
        items.append(DataTableItem(headerTitle: FBOption.flowchart, itemTitle: self.flowchart))
        items.append(DataTableItem(headerTitle: FBOption.roadMap, itemTitle: self.roadMap))
        return items
    }
}

//struct Option: DataProtocol, Hashable {
//    let id: String
//    let dataCase: SEESData = .majors
//    var majorPath: String = ""
//    var path: String {
//        return "\(self.majorPath)/\(self.optionName)"
//    }
//
//    var majorName: FBMajor = .none
//    let optionName: String
//    let curriculumSheet: String
//    let flowchart: String
//    let roadMap: String
//
//    init(id: String, dictionary: [String: Any], majorName: FBMajor, majorPath: String) {
//        self.init(id: id, dictionary: dictionary)
//        self.majorName = majorName
//        self.majorPath = majorPath
//    }
//
//    internal init(id: String, dictionary: [String: Any]) {
//        self.id = id
//        self.optionName = dictionary[FBOption.optionName] as? String ?? "optionNameError"
//        self.curriculumSheet = dictionary[FBOption.curriculumSheet] as? String ?? "curriculumSheetError"
//        self.flowchart = dictionary[FBOption.flowchart] as? String ?? "flowchartError"
//        self.roadMap = dictionary[FBOption.roadMap] as? String ?? "roadMapError"
//    }
//
//    init() {
//        self.id = ""
//        self.optionName = ""
//        self.curriculumSheet = ""
//        self.flowchart = ""
//        self.roadMap = ""
//    }
//
//    var tableItems: [DataTableItem] {
//        var items: [DataTableItem] = []
//        items.append(DataTableItem(headerTitle: FBOption.optionName, itemTitle: self.optionName))
//        items.append(DataTableItem(headerTitle: FBOption.curriculumSheet, itemTitle: self.curriculumSheet))
//        items.append(DataTableItem(headerTitle: FBOption.flowchart, itemTitle: self.flowchart))
//        items.append(DataTableItem(headerTitle: FBOption.roadMap, itemTitle: self.roadMap))
//        return items
//    }
//}
//
//struct Major: DataProtocol, Hashable {
//    let id: String
//    let dataCase: SEESData = .majors
//    var path: String {
//        return "/\(FirebaseValue.majors)/\(self.id)"
//    }
//
//    var options: [Option] = []
//
//    init(id: String, dictionary: [String : Any]) {
//        self.id = id
//
//        for(key, value) in dictionary {
//            if let optionsDictionary = value as? [String: Any] {
//                options.append(Option(id: key, dictionary: optionsDictionary, majorName: FBMajor(rawValue: self.id) ?? .none, majorPath: self.path))
//            }
//        }
//    }
//
//    init() {
//        self.id = ""
//    }
//
//    var tableItems: [DataTableItem] {
//        return []
//    }
//}
