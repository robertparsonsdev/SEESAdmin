//
//  ViewController.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/6/20.
//

import UIKit

class ListViewController: UIViewController {
    static let storyboardID = "ListViewControllerID"
    static func instantiateFromStoryboard() -> ListViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(identifier: storyboardID) as? ListViewController
    }
    
    private enum ListItemType: Int {
        case header, row
    }
    
    private enum ListSection: Int {
        case main
    }
    
    private struct ListItem: Hashable, Identifiable {
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
    
    private let networkManager = NetworkManager.shared
    private var activeData: SEESData = .students
    private var students: [Student] = []
    private var majors: [Major] = []
    private var events: [Event] = []
    private var contacts: [Contact] = []
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<ListSection, ListItem>!
    
    // MARK: - View Controller Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureCollectionView()
        configureDataSource()
        
        fetchData()
    }
    
    // MARK: - Configuration Functions
    private func configureView() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.tintColor = .systemTeal
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.tintColor = .systemTeal
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ListItem> { (cell, indexPath, item) in
            var contentConfiguration = UIListContentConfiguration.groupedHeader()
            contentConfiguration.text = item.title
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .subheadline)
            contentConfiguration.textProperties.color = .secondaryLabel
            
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.outlineDisclosure()]
        }
        
        let rowRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ListItem> { (cell, indexPath, item) in
            var contentConfiguration = UIListContentConfiguration.cell()
            contentConfiguration.text = item.title
            
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<ListSection, ListItem>(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item.type {
            case .header: return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
            case .row: return collectionView.dequeueConfiguredReusableCell(using: rowRegistration, for: indexPath, item: item)
            }
        })
    }
    
    // MARK: - Functions
    public func show(_ data: SEESData) {
        self.activeData = data
        self.dataSource.apply(dataSnapshot(), to: .main, animatingDifferences: true, completion: nil)
    }
    
    private func fetchData() {
        self.networkManager.fetchData { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let dataDictionary):
                self.students = dataDictionary[.students] as! [Student]
                self.majors = dataDictionary[.majors] as! [Major]
                self.events = dataDictionary[.events] as! [Event]
                self.contacts = dataDictionary[.contacts] as! [Contact]
            case .failure(let error): print(error)
            }
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout() { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.showsSeparators = true
            configuration.headerMode = .firstItemInSection
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            return section
        }
        
        return layout
    }
    
//    private func studentsSnapshot() -> NSDiffableDataSourceSectionSnapshot<ListItem> {
//
//    }
//
//    private func majorsSnapshot() -> NSDiffableDataSourceSectionSnapshot<ListItem> {
//
//    }
//
//    private func eventsSnapshot() -> NSDiffableDataSourceSectionSnapshot<ListItem> {
//
//    }
//
//    private func contactsSnapshot() -> NSDiffableDataSourceSectionSnapshot<ListItem> {
//
//    }
    
    private func dataSnapshot() -> NSDiffableDataSourceSectionSnapshot<ListItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
        let header = ListItem.header(title: "Header")
        var items: [ListItem] = []
        
        switch self.activeData {
        case .students:
            for student in self.students {
                items.append(.row(title: student.firstName))
            }
        case .majors:
            for major in self.majors {
                items.append(.row(title: major.options[0].optionName))
            }
        case .events:
            for event in self.events {
                items.append(.row(title: event.eventName))
            }
        case .contacts:
            for contact in self.contacts {
                items.append(.row(title: contact.name))
            }
        }
        
        snapshot.append([header])
        snapshot.expand([header])
        snapshot.append(items, to: header)
        
        return snapshot
    }
}

extension ListViewController: UICollectionViewDelegate {
    
}
