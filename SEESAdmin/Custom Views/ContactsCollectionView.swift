//
//  ContactsCollectionView.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/10/20.
//

import UIKit

class ContactsCollectionView: DataCollectionView {
    private let sectionDictionary: [String: [Contact]]
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, sectionDictionary: [String: [Contact]]) {
        self.sectionDictionary = sectionDictionary
        super.init(frame: frame, collectionViewLayout: layout)
        
        applyInitialSnapshot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ContactsCollectionView: DataCollectionViewDelegate {
    func applyInitialSnapshot() {
        let sections = ContactsSection.allCases
        var headers: [ListItem] = []
        for section in sections {
            headers.append(.header(title: section.rawValue))
        }
        
        var sectionSnapshot: NSDiffableDataSourceSectionSnapshot<ListItem>
        var rows: [ListItem]
        for header in headers {
            sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
            sectionSnapshot.append([header])
            sectionSnapshot.expand([header])
            rows = []
            
            if let contacts = self.sectionDictionary[header.title] {
                for contact in contacts {
                    rows.append(.row(title: "\(contact.name)"))
                }
                
                sectionSnapshot.append(rows, to: header)
                self.diffableDataSource.apply(sectionSnapshot, to: header, animatingDifferences: true, completion: nil)
            }
        }
    }
}

enum ContactsSection: String, CaseIterable {
    case contacts = "contacts"
}
