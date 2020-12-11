//
//  MajorsCollectionView.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/9/20.
//

import UIKit

class MajorsCollectionView: DataCollectionView {
    private let sectionDictionary: [String: [Option]]

    init(frame: CGRect, sectionDictionary: [String: [Option]], delegate: UICollectionViewDelegate) {
        self.sectionDictionary = sectionDictionary
        super.init(frame: frame, collectionViewLayout: UIHelper.createDataLayout())
        self.delegate = delegate
        
        applyInitialSnapshot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MajorsCollectionView: DataCollectionViewDelegate {
    func applyInitialSnapshot() {
        let sections = MajorsSection.allCases
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
            
            if let options = self.sectionDictionary[header.title] {
                for option in options {
                    rows.append(.row(title: option.optionName))
                }
                
                sectionSnapshot.append(rows, to: header)
                self.diffableDataSource.apply(sectionSnapshot, to: header, animatingDifferences: true, completion: nil)
            }
        }
    }
}

enum MajorsSection: String, CaseIterable {
    case biology = "biology"
    case biotech = "biotechnology"
    case chem = "chemistry"
    case cs = "computer science"
    case envBio = "environmental biology"
    case geo = "geology"
    case kin = "kinesiology"
    case math = "mathematics"
    case phy = "physics"
}
