//
//  SidebarViewController.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/6/20.
//

import UIKit

class SidebarViewController: UIViewController {
    private enum SidebarItemType: Int {
        case header, row
    }
    
    private enum SidebarSection: Int {
        case data
    }
    
    private struct SidebarItem: Hashable, Identifiable {
        let id: UUID
        let type: SidebarItemType
        let title: String
        let subtitle: String?
        let image: UIImage?
        
        static func header(title: String, id: UUID = UUID()) -> Self {
            return SidebarItem(id: id, type: .header, title: title, subtitle: nil, image: nil)
        }
        
        static func row(title: String, subtitle: String?, image: UIImage?, id: UUID = UUID()) -> Self {
            return SidebarItem(id: id, type: .row, title: title, subtitle: subtitle, image: image)
        }
    }
    
    private struct RowIdentifier {
        static let students = UUID()
        static let majors = UUID()
        static let events = UUID()
        static let contacts = UUID()
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SidebarSection, SidebarItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureCollectionView()
        configureDataSource()
        applyInitialSnapshot()
    }
    
    // MARK: - Configuration Functions
    private func configureView() {
        self.navigationController?.navigationBar.tintColor = .systemTeal
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "SEES Admin"
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createSidebarLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.tintColor = .systemTeal
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> { (cell, indexPath, item) in
            var contentConfiguration = UIListContentConfiguration.sidebarHeader()
            contentConfiguration.text = item.title
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .subheadline)
            contentConfiguration.textProperties.color = .secondaryLabel
            
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.outlineDisclosure()]
        }
        
        let rowResgistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> { (cell, indexPath, item) in
            var contentConfiguration = UIListContentConfiguration.sidebarSubtitleCell()
            contentConfiguration.text = item.title
            contentConfiguration.secondaryText = item.subtitle
            contentConfiguration.image = item.image
            
            cell.contentConfiguration = contentConfiguration
        }
        
        dataSource = UICollectionViewDiffableDataSource<SidebarSection, SidebarItem>(collectionView: self.collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell in
            switch item.type {
            case .header: return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
            case .row: return collectionView.dequeueConfiguredReusableCell(using: rowResgistration, for: indexPath, item: item)
            }
        }
    }
    
    private func dataSnapshot() -> NSDiffableDataSourceSectionSnapshot<SidebarItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<SidebarItem>()
        let header = SidebarItem.header(title: "Data")
        let items: [SidebarItem] = [
            .row(title: "Students", subtitle: nil, image: UIImage(systemName: "person.2.fill"), id: RowIdentifier.students),
            .row(title: "Majors", subtitle: nil, image: UIImage(systemName: "studentdesk"), id: RowIdentifier.majors),
            .row(title: "Events", subtitle: nil, image: UIImage(systemName: "calendar"), id: RowIdentifier.events),
            .row(title: "Contacts", subtitle: nil, image: UIImage(systemName: "person.crop.circle.fill"), id: RowIdentifier.contacts)
        ]
        
        snapshot.append([header])
        snapshot.expand([header])
        snapshot.append(items, to: header)
        
        return snapshot
    }
    
    private func applyInitialSnapshot() {
        self.dataSource.apply(dataSnapshot(), to: .data, animatingDifferences: false)
    }
    
    // MARK: - Functions
    private func listViewController() -> DataListViewController? {
        guard let splitVC = self.splitViewController, let listVC = splitVC.viewController(for: .supplementary) else { return nil }
        return listVC as? DataListViewController
    }
}

extension SidebarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sidebarItem = self.dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch indexPath.section {
        case SidebarSection.data.rawValue: didSelectDataItem(sidebarItem, at: indexPath)
        default: collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    private func didSelectDataItem(_ sidebarItem: SidebarItem, at indexPath: IndexPath) {
        guard let listVC = listViewController() else { return }
        
        switch sidebarItem.id {
        case RowIdentifier.students: listVC.show(.students)
        case RowIdentifier.majors: listVC.show(.majors)
        case RowIdentifier.events: listVC.show(.events)
        case RowIdentifier.contacts: listVC.show(.contacts)
        default: break
        }
    }
}
