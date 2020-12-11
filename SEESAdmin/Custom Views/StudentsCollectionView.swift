//
//  StudentsCollectionView.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/9/20.
//

import UIKit

class StudentsCollectionView: DataCollectionView {
    private let sectionDictionary: [String: [Student]]

    init(frame: CGRect, sectionDictionary: [String: [Student]], delegate: UICollectionViewDelegate) {
        self.sectionDictionary = sectionDictionary
        super.init(frame: frame, collectionViewLayout: UIHelper.createDataLayout())
        self.delegate = delegate

        applyInitialSnapshot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StudentsCollectionView: DataCollectionViewDelegate {
    func applyInitialSnapshot() {
        let sections = StudentsSection.allCases
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
            
            if let students = self.sectionDictionary[header.title] {
                for student in students {
                    rows.append(.row(title: "\(student.lastName), \(student.firstName)"))
                }
                
                sectionSnapshot.append(rows, to: header)
                self.diffableDataSource.apply(sectionSnapshot, to: header, animatingDifferences: false, completion: nil)
            }
        }
    }
}

//extension StudentsCollectionView: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let listItem = self.diffableDataSource.itemIdentifier(for: indexPath) else { return }
//
//        print(listItem.title)
//    }
//}

enum StudentsSection: String, CaseIterable {
    case a = "A", b = "B", c = "C", d = "D", e = "E", f = "F", g = "G", h = "H", i = "I", j = "J", k = "K", l = "L",
         m = "M", n = "N", o = "O", p = "P", q = "Q", r = "R", s = "S", t = "T", u = "U", v = "V", w = "W", x = "X", y = "Y", z = "Z",
         error = "error"
}
