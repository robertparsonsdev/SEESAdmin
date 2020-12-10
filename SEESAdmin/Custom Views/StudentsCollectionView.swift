//
//  StudentsCollectionView.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/9/20.
//

import UIKit

class StudentsCollectionView: DataCollectionView {
    private var diffableDataSource: UICollectionViewDiffableDataSource<StudentsSection, ListItem>!
    private let sectionDictionary: [StudentsSection: [Student]]

    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, sectionDictionary: [StudentsSection: [Student]]) {
        self.sectionDictionary = sectionDictionary
        super.init(frame: frame, collectionViewLayout: layout)
        
        configureDiffableDataSource()
        applySnapshot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StudentsCollectionView: DataCollectionViewDelegate {
    func configureDiffableDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<StudentsSection, ListItem>(collectionView: self, cellProvider: { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            switch item.type {
            case .header: return collectionView.dequeueConfiguredReusableCell(using: self.headerRegistration, for: indexPath, item: item)
            case .row: return collectionView.dequeueConfiguredReusableCell(using: self.rowRegistration, for: indexPath, item: item)
            }
        })
    }
    
    func applySnapshot() {
        var snapshot: NSDiffableDataSourceSectionSnapshot<ListItem>
        var header: ListItem
        var rows: [ListItem]
        
        for (key, value) in self.sectionDictionary {
            snapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
            header = .header(title: key.rawValue)
            rows = []

            for student in value {
                rows.append(.row(title: "\(student.lastName), \(student.firstName)"))
            }

            snapshot.append([header])
            snapshot.expand([header])
            snapshot.append(rows, to: header)

            self.diffableDataSource.apply(snapshot, to: key, animatingDifferences: true, completion: nil)
        }
    }
}

enum StudentsSection: String, CaseIterable {
    case a = "A", b = "B", c = "C", d = "D", e = "E", f = "F", g = "G", h = "H", i = "I", j = "J", k = "K", l = "L",
         m = "M", n = "N", o = "O", p = "P", q = "Q", r = "R", s = "S", t = "T", u = "U", v = "V", w = "W", x = "X", y = "Y", z = "Z"
}
