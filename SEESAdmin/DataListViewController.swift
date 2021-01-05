//
//  DataViewController.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/6/20.
//

import UIKit

class DataListViewController: UIViewController {
    private let cellID = "ListTableCellID"
    static let storyboardID = "ListViewControllerID"
    static func instantiateFromStoryboard() -> DataListViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(identifier: storyboardID) as? DataListViewController
    }
    
    private let networkManager = NetworkManager.shared
    private var studentSectionDictionary = [String: [ListItem]]()
    private var optionSectionDictionary = [String: [ListItem]]()
    private var eventSectionDictionary = [String: [ListItem]]()
    private var contactSectionDictionary = [String: [ListItem]]()
    
    private var tableView: UITableView!
    private var dataSource: ListDataSource!
    
    private var activeData: SEESData! {
        didSet {
            guard activeData != oldValue else { return }
            
            switch activeData {
            case .students: applyListSnapshot(with: self.studentSectionDictionary)
            case .options: applyListSnapshot(with: self.optionSectionDictionary)
            case .events: applyListSnapshot(with: self.eventSectionDictionary)
            case .contacts: applyListSnapshot(with: self.contactSectionDictionary)
            case .none: break
            }
        }
    }
    
    // MARK: - View Controller Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureTableView()
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
    
    private func configureTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .insetGrouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.tintColor = .systemTeal
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        self.view.addSubview(tableView)
    }
    
    private func configureDataSource() {
        dataSource = ListDataSource(tableView: self.tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
            cell.textLabel?.text = item.row
            cell.accessoryType = .disclosureIndicator
            return cell
        })
    }
    
    // MARK: - Functions
    public func show(_ data: SEESData) {
        self.activeData = data
    }
    
    private func fetchData() {
        showLoadingViewOnMainThread()
        self.networkManager.fetchData { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let dataDictionary):
                self.configureSections(with: dataDictionary[.students] as! [Student], and: &self.studentSectionDictionary)
                self.configureSections(with: dataDictionary[.options] as! [Option], and: &self.optionSectionDictionary)
                self.configureSections(with: dataDictionary[.events] as! [Event], and: &self.eventSectionDictionary)
                self.configureSections(with: dataDictionary[.contacts] as! [Contact], and: &self.contactSectionDictionary)
                DispatchQueue.main.async { self.activeData = .students }
                
            case .failure(let error):
                self.presentErrorOnMainThread(withError: .unableToFetchData, optionalMessage: "\n\n\(error.localizedDescription)")
            }
            
            self.dismissLoadingViewOnMainThread()
        }
    }
    
    private func applyListSnapshot(with dictionary: [String: [ListItem]]) {
        var snapshot = NSDiffableDataSourceSnapshot<String, ListItem>()
        let sections = Array(dictionary.keys).sorted(by: { $0 < $1 })
        snapshot.appendSections(sections)
        
        for section in sections {
            if let dataArray = dictionary[section] {
                snapshot.appendItems(dataArray, toSection: section)
            }
        }
        
        self.dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
    }
    
    private func configureSections(with dataArray: [DataProtocol], and dictionary: inout [String: [ListItem]]) {
        for data in dataArray.sorted(by: { $0.row < $1.row }) {
            let key = data.header
            if dictionary[key] == nil {
                dictionary[key] = []
            }
            
            dictionary[key]?.append(.row(data: data))
        }
    }
    
    // MARK: - Selectors
    @objc func addButtonTapped() {
        let data: DataProtocol
        switch self.activeData {
        case .students: data = Student()
        case .options: data = Option()
        case .events: data = Event()
        case .contacts: data = Contact()
        case .none: return
        }
        
        presentDataEditingVC(with: data, editing: false, delegate: self)
    }
}

// MARK: - Delegates
extension DataListViewController: DataEditingDelegate {
    func reload(with data: DataProtocol) {
        var snapshot = self.dataSource.snapshot()
        guard let item = snapshot.itemIdentifiers.first(where: { $0.id == data.id }) else { return }
        let oldSection = item.header, newSection = data.header
        
        item.row = data.row
        item.header = data.header
        item.set(data: data)
        snapshot.reloadItems([item])
        
        // move item within section

//        if data.listHeader != item.headerTitle {
//            let oldHeader = item.headerTitle, newHeader = data.listHeader
//            item.headerTitle = data.listHeader
//
//            if snapshot.sectionIdentifiers.contains(newHeader) {
//                snapshot.deleteItems([item])
//                snapshot.appendItems([item], toSection: newHeader)
//                if snapshot.numberOfItems(inSection: oldHeader) == 0 {
//                    snapshot.deleteSections([oldHeader])
//                }
//            } else {
//
//            }
//        }
        
//        let oldHeader = item.headerTitle, newHeader = data.listHeader
//        if let
//
//        self.dataSource.apply(snapshot, animatingDifferences: true)
        if oldSection != newSection {
            if var items = self.studentSectionDictionary[newSection] {
                let index = items.getInsertionIndex(of: item)
                items.insert(item, at: index)
                self.studentSectionDictionary[newSection] = items
                snapshot.appendItems(items, toSection: newSection)

                if let oldItems = self.studentSectionDictionary[oldSection] {
                    self.studentSectionDictionary[oldSection] = oldItems.filter { $0 != item }
                    snapshot.appendItems(self.studentSectionDictionary[oldSection]!, toSection: oldSection)
                    if self.studentSectionDictionary[oldSection]!.isEmpty {
                        print("empty")
                        snapshot.deleteSections([oldSection])
                    }
                }
                
            } else {
                self.studentSectionDictionary[newSection] = []
            }
            
            didSelectDataItem(item)
        }
        
        self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        
        let indexPath = self.dataSource.indexPath(for: item)
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
    }
}

extension DataListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let listItem = self.dataSource.itemIdentifier(for: indexPath) else { return }
        didSelectDataItem(listItem)
    }
    
    private func didSelectDataItem(_ item: ListItem) {
        guard let data = item.getData() else { return }
        
        let detailVC = DataDetailViewController(data: data, delegate: self)
        detailVC.title = item.row
        let navController = UINavigationController(rootViewController: detailVC)
        showDetailViewController(navController, sender: self)
    }
}

class ListDataSource: UITableViewDiffableDataSource<String, ListItem> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let item = itemIdentifier(for: IndexPath(row: 0, section: section)) {
            return item.header
        }
        return "error"
    }
}

class ListItem: Hashable, Identifiable, Comparable {
    static func < (lhs: ListItem, rhs: ListItem) -> Bool {
        return lhs.row < rhs.row
    }
    
    static func == (lhs: ListItem, rhs: ListItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    let id: String
    var header: String
    var row: String
    
    private var student: Student?
    private var option: Option?
    private var event: Event?
    private var contact: Contact?
    
    private init(id: String, headerTitle: String, rowTitle: String, student: Student? = nil, option: Option? = nil, event: Event? = nil, contact: Contact? = nil) {
        self.id = id
        self.header = headerTitle
        self.row = rowTitle
        
        self.student = student
        self.option = option
        self.event = event
        self.contact = contact
    }
    
    static func row(data: DataProtocol) -> ListItem {
        switch data.dataCase {
        case .students: return ListItem(id: data.id, headerTitle: data.header, rowTitle: data.row, student: data as? Student)
        case .options: return ListItem(id: data.id, headerTitle: data.header, rowTitle: data.row, option: data as? Option)
        case .events: return ListItem(id: data.id, headerTitle: data.header, rowTitle: data.row, event: data as? Event)
        case .contacts: return ListItem(id: data.id, headerTitle: data.header, rowTitle: data.row, contact: data as? Contact)
        }
    }
    
    func getData() -> DataProtocol? {
        if let student = self.student { return student }
        else if let option = self.option { return option }
        else if let event = self.event { return event }
        else if let contact = self.contact { return contact }
        else { return nil }
    }
    
    func set(data: DataProtocol) {
        switch data.dataCase {
        case .students: self.student = data as? Student
        case .options: self.option = data as? Option
        case .events: self.event = data as? Event
        case .contacts: self.contact = data as? Contact
        }
    }
}
