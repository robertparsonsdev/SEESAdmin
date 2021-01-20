//
//  SnapshotEXT.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 1/7/21.
//

import UIKit

extension NSDiffableDataSourceSnapshot where ItemIdentifierType == DataModel, SectionIdentifierType == String {
//    mutating func insertAndReload(model: DataModel) {
//        deleteFromOldSection(model: model)
//        moveModelToNewSection(model: model)
//        reloadItems([model])
//    }
//
//    mutating func deleteFromOldSection(model: DataModel) {
//        guard itemIdentifiers.contains(model) else { return }
//
//        if let oldSection = sectionIdentifier(containingItem: model) {
//            var sectionItems = itemIdentifiers(inSection: oldSection)
//            if let index = sectionItems.firstIndex(of: model) {
//                sectionItems.remove(at: index)
//            }
//
//            if sectionItems.isEmpty {
//                deleteSections([oldSection])
//            } else {
//                reappend(section: oldSection, with: sectionItems)
//            }
//        }
//    }
//
//    mutating func moveModelToNewSection(model: DataModel) {
//        if let existingSection = sectionIdentifiers.first(where: { $0 == model.header }) {
//            var sectionItems = itemIdentifiers(inSection: existingSection)
//            let index = sectionItems.getInsertionIndex(of: model)
//            sectionItems.insert(model, at: index)
//
//            reappend(section: existingSection, with: sectionItems)
//        } else {
//            insertSectionInOrder(model.header, with: [model])
//        }
//    }
    
    mutating func reinsert(section: String, with models: [DataModel], for type: FBDataType) {
        deleteSections([section])
        insertSectionInOrder(section, with: models, for: type)
    }
    
    mutating func insertSectionInOrder(_ section: String, with models: [DataModel], for type: FBDataType) {
        let sections: [String]
        let index: Array<String>.Index
        
        switch type {
        case .events:
            let dateSections = sectionIdentifiers.map { $0.convertToMonthYear() }
            index = dateSections.getInsertionIndex(of: section.convertToMonthYear())
            sections = dateSections.map { $0.convertToEventHeader() }
        default:
            sections = sectionIdentifiers
            index = sections.getInsertionIndex(of: section)
        }
        
        if index == 0, let firstSection = sections.first {
            insertSections([section], beforeSection: firstSection)
        } else if index == sections.count, let lastSection = sections.last {
            insertSections([section], afterSection: lastSection)
        } else if !sections.isEmpty {
            insertSections([section], beforeSection: sections[index])
        } else {
            appendSections([section])
        }
        
        appendItems(models, toSection: section)
    }
}
