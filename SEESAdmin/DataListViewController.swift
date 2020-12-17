//
//  DataViewController.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/6/20.
//

import UIKit

class DataListViewController: UIViewController {
    static let storyboardID = "ListViewControllerID"
    static func instantiateFromStoryboard() -> DataListViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(identifier: storyboardID) as? DataListViewController
    }
    
    private let networkManager = NetworkManager.shared
    private var studentSectionDictionary = [String: [Student]]()
    private var majorSectionDictionary = [String: [Option]]()
    private var eventSectionDictionary = [String: [Event]]()
    private var contactSectionDictionary = [String: [Contact]]()
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<ListItem, ListItem>!
    private var activeData: SEESData! {
        didSet {
            switch activeData {
            case .students: applyInitialSnapshot(with: self.studentSectionDictionary)
            case .majors: applyInitialSnapshot(with: self.majorSectionDictionary)
            case .events: applyInitialSnapshot(with: self.eventSectionDictionary)
            case .contacts: applyInitialSnapshot(with: self.contactSectionDictionary)
            case .none: break
            }
        }
    }
    
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
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: UIHelper.createDataLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.tintColor = .systemTeal
        collectionView.delegate = self
        self.view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ListItem> { (cell, indexPath, item) in
                var contentConfiguration = UIListContentConfiguration.groupedHeader()
                contentConfiguration.text = item.headerTitle
                contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .subheadline)
                contentConfiguration.textProperties.color = .secondaryLabel
                
                cell.contentConfiguration = contentConfiguration
        }
        let rowRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ListItem> { (cell, indexPath, item) in
                var contentConfiguration = UIListContentConfiguration.cell()
                contentConfiguration.text = item.rowTitle
                
                cell.contentConfiguration = contentConfiguration
                cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<ListItem, ListItem>(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item.type {
            case .header: return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
            case .row: return collectionView.dequeueConfiguredReusableCell(using: rowRegistration, for: indexPath, item: item)
            }
        })
    }
    
    // MARK: - Functions
    public func show(_ data: SEESData) {
        self.activeData = data
    }
    
    private func fetchData() {
        showLoadingView()
        self.networkManager.fetchData { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let dataDictionary):
                self.configure(studentData: dataDictionary[.students] as! [Student])
                self.configure(majorData: dataDictionary[.majors] as! [Major])
                self.configure(eventsData: dataDictionary[.events] as! [Event])
                self.configure(contactsData: dataDictionary[.contacts] as! [Contact])
            case .failure(let error):
                self.presentErrorOnMainThread(withError: .unableToFetchData, optionalMessage: "\n\n\(error.localizedDescription)")
            }
            self.dismissLoadingView()
        }
    }
    
    private func applyInitialSnapshot<T: DataProtocol>(with dictionary: [String: [T]]) {
        var snapshot = NSDiffableDataSourceSnapshot<ListItem, ListItem>()

        let sections: [String] = Array(dictionary.keys).sorted(by: { $0 < $1 })
        var headers: [ListItem] = []
        for section in sections {
            headers.append(.header(title: section))
        }
        snapshot.appendSections(headers)
        
        var rows: [ListItem]
        for header in headers {
            rows = []
            rows.append(header)
            
            if let dataArray = dictionary[header.headerTitle!] {
                for data in dataArray {
                    if let student = data as? Student { rows.append(.row(student: student)) }
                    else if let option = data as? Option { rows.append(.row(option: option)) }
                    else if let event = data as? Event { rows.append(.row(event: event)) }
                    else if let contact = data as? Contact { rows.append(.row(contact: contact)) }
                }
                
                snapshot.appendItems(rows, toSection: header)
            }
        }
        
        self.dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
    }
    
    private func configure(studentData: [Student]) {
        for student in studentData {
            let letter = String(student.lastName.first ?? Character("error")).uppercased()
            
            if var array = self.studentSectionDictionary[letter] {
                array.append(student)
            } else {
                self.studentSectionDictionary[letter] = []
                self.studentSectionDictionary[letter]?.append(student)
            }
        }
    }
    
    private func configure(majorData: [Major]) {
        for major in majorData {
            let majorName = major.majorName.lowercased()
            
            if var array = self.majorSectionDictionary[majorName] {
                array.append(contentsOf: major.options)
            } else {
                self.majorSectionDictionary[majorName] = []
                self.majorSectionDictionary[majorName]?.append(contentsOf: major.options)
            }
        }
    }
    
    private func configure(eventsData: [Event]) {
        self.eventSectionDictionary["Events"] = eventsData.sorted { $0.startDate < $1.startDate }
    }
    
    private func configure(contactsData: [Contact]) {
        self.contactSectionDictionary["Contacts"] = contactsData.sorted { $0.order < $1.order }
    }
    
    // MARK: - Selectors
    @objc func addButtonTapped() {
        let data: DataProtocol
        switch self.activeData {
        case .students: data = Student()
        case .majors: data = Option()
        case .events: data = Event()
        case .contacts: data = Contact()
        case .none: return
        }
        
        let navController = UINavigationController(rootViewController: DataEditingViewController(data: data, editing: false))
        present(navController, animated: true, completion: nil)
    }
}

extension DataListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let listItem = self.dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch listItem.type {
        case .row: didSelectDataItem(listItem)
        case .header: collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    private func didSelectDataItem(_ item: ListItem) {
        guard let data = item.getData() else { return }
        
        let detailVC = DataDetailViewController(data: data)
        detailVC.title = item.rowTitle
        let navController = UINavigationController(rootViewController: detailVC)
        showDetailViewController(navController, sender: self)
    }
}

enum ListItemType: Int {
    case header, row
}

struct ListItem: Hashable, Identifiable {
    let id: UUID
    let type: ListItemType
    var headerTitle: String?
    
    var rowTitle: String? {
        if let student = self.student { return "\(student.lastName), \(student.firstName)" }
        else if let option = self.option { return option.optionName }
        else if let event = self.event { return event.eventName }
        else if let contact = self.contact { return contact.name }
        else { return "error" }
    }
    var data: SEESData? {
        if self.student != nil { return .students }
        else if self.option != nil { return .majors }
        else if self.event != nil { return .events }
        else if self.contact != nil { return .contacts }
        else { return nil }
    }
    
    var student: Student?
    var option: Option?
    var event: Event?
    var contact: Contact?
    
    static func header(title: String) -> Self {
        return ListItem(id: UUID(), type: .header, headerTitle: title)
    }
    
    static func row(student: Student) -> Self {
        return ListItem(id: UUID(), type: .row, student: student)
    }
    
    static func row(option: Option) -> Self {
        return ListItem(id: UUID(), type: .row, option: option)
    }
    
    static func row(event: Event) -> Self {
        return ListItem(id: UUID(), type: .row, event: event)
    }
    
    static func row(contact: Contact) -> Self {
        return ListItem(id: UUID(), type: .row, contact: contact)
    }
    
    func getData() -> DataProtocol? {
        if let student = self.student { return student }
        else if let option = self.option { return option }
        else if let event = self.event { return event }
        else if let contact = self.contact { return contact }
        else { return nil }
    }
}
