//
//  SnapshotEXT.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 1/7/21.
//

import UIKit

extension NSDiffableDataSourceSnapshot where ItemIdentifierType == DataModel, SectionIdentifierType == String {
    mutating func insertAndReload(model: DataModel) {
        deleteFromOldSection(model: model)
        appendToNewSection(model: model)
        reloadItems([model])
    }
    
    mutating func deleteFromOldSection(model: DataModel) {
        guard itemIdentifiers.contains(model) else { return }
        
        if let oldSection = sectionIdentifier(containingItem: model) {
            var sectionItems = itemIdentifiers(inSection: oldSection)
            if let index = sectionItems.firstIndex(of: model) {
                sectionItems.remove(at: index)
            }
            
            if sectionItems.isEmpty {
                deleteSections([oldSection])
            } else {
                reappend(section: oldSection, with: sectionItems)
            }
        }
    }
    
    mutating func appendToNewSection(model: DataModel) {
        if let existingSection = sectionIdentifiers.first(where: { $0 == model.header }) {
            var sectionItems = itemIdentifiers(inSection: existingSection)
            let index = sectionItems.getInsertionIndex(of: model)
            sectionItems.insert(model, at: index)
            
            reappend(section: existingSection, with: sectionItems)
        } else {
            let sections = sectionIdentifiers
            let newSection = [model.header]
            let index = sections.getInsertionIndex(of: model.header)
            
            if index == 0, let firstSection = sections.first {
                insertSections(newSection, beforeSection: firstSection)
            } else if index == sections.count, let lastSection = sections.last {
                insertSections(newSection, afterSection: lastSection)
            } else if !sections.isEmpty {
                insertSections(newSection, afterSection: sections[index])
            } else {
                appendSections(newSection)
            }
            
            appendItems([model], toSection: model.header)
        }
    }
    
    mutating func reappend(section: String, with items: [DataModel]) {
        deleteSections([section])
        appendSections([section])
        appendItems(items, toSection: section)
    }
}
