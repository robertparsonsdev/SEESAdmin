//
//  DataCollectionView.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/9/20.
//

import UIKit

protocol DataCollectionViewDelegate {
    func configureDiffableDataSource()
    func applySnapshot()
}

class DataCollectionView: UICollectionView {
    var headerRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, ListItem> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, ListItem> { (cell, indexPath, item) in
            var contentConfiguration = UIListContentConfiguration.groupedHeader()
            contentConfiguration.text = item.title
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .subheadline)
            contentConfiguration.textProperties.color = .secondaryLabel
            
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.outlineDisclosure()]
        }
    }
    var rowRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, ListItem> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, ListItem> { (cell, indexPath, item) in
            var contentConfiguration = UIListContentConfiguration.cell()
            contentConfiguration.text = item.title
            
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.disclosureIndicator()]
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .systemBackground
        tintColor = .systemTeal
    }
    
    enum ListItemType: Int {
        case header, row
    }

    struct ListItem: Hashable, Identifiable {
        let id: UUID
        let type: ListItemType
        let title: String
        
        static func header(title: String, id: UUID = UUID()) -> Self {
            return ListItem(id: id, type: .header, title: title)
        }
        
        static func row(title: String, id: UUID = UUID()) -> Self {
            return ListItem(id: id, type: .row, title: title)
        }
    }
}
