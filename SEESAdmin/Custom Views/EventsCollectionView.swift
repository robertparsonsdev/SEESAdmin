//
//  EventsCollectionView.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/10/20.
//

import UIKit

class EventsCollectionView: DataCollectionView {
    private let sectionDictionary: [String: [Event]]
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, sectionDictionary: [String: [Event]]) {
        self.sectionDictionary = sectionDictionary
        super.init(frame: frame, collectionViewLayout: layout)
        
        applyInitialSnapshot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EventsCollectionView: DataCollectionViewDelegate {
    func applyInitialSnapshot() {
        let sections = EventsSection.allCases
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
            
            if let events = self.sectionDictionary[header.title] {
                for event in events {
                    rows.append(.row(title: event.eventName))
                }
                
                sectionSnapshot.append(rows, to: header)
                self.diffableDataSource.apply(sectionSnapshot, to: header, animatingDifferences: true, completion: nil)
            }
        }
    }
}

enum EventsSection: String, CaseIterable {
    case events = "events"
}
