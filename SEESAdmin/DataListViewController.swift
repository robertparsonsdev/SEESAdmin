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
    private var studentSectionDictionary = [String: [DataModel]]()
    private var optionSectionDictionary = [String: [DataModel]]()
    private var eventSectionDictionary = [String: [DataModel]]()
    private var contactSectionDictionary = [String: [DataModel]]()
    
    private var tableView: UITableView!
    private var dataSource: ListDataSource!
    
    private var activeData: FBDataType! {
        didSet {
            guard activeData != oldValue else { return }
            
            switch activeData {
            case .students: applyListSnapshot(with: self.studentSectionDictionary, animate: false)
            case .options: applyListSnapshot(with: self.optionSectionDictionary, animate: false)
            case .events: applyListSnapshot(with: self.eventSectionDictionary, animate: false)
            case .contacts: applyListSnapshot(with: self.contactSectionDictionary, animate: false)
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
            print(item.row)
            cell.textLabel?.text = item.row
            cell.accessoryType = .disclosureIndicator
            return cell
        })
    }
    
    // MARK: - Functions
    public func show(_ data: FBDataType) {
        self.activeData = data
    }
    
    private func fetchData() {
        showLoadingViewOnMainThread()
        self.networkManager.fetchData { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let dataDictionary):
                self.configureSections(with: dataDictionary[.students] ?? [], and: &self.studentSectionDictionary)
                self.configureSections(with: dataDictionary[.options] ?? [], and: &self.optionSectionDictionary)
                self.configureSections(with: dataDictionary[.events] ?? [], and: &self.eventSectionDictionary)
                self.configureSections(with: dataDictionary[.contacts] ?? [], and: &self.contactSectionDictionary)
                DispatchQueue.main.async { self.activeData = .students }
                
            case .failure(let error):
                self.presentErrorOnMainThread(withError: .unableToFetchData, optionalMessage: "\n\n\(error.localizedDescription)")
            }
            
            self.dismissLoadingViewOnMainThread()
        }
    }
    
    private func applyListSnapshot(with dictionary: [String: [DataModel]], animate: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<String, DataModel>()
        let sections = Array(dictionary.keys).sorted(by: { $0 < $1 })
        snapshot.appendSections(sections)

        for section in sections {
            if let dataArray = dictionary[section] {
                snapshot.appendItems(dataArray, toSection: section)
            }
        }

        self.dataSource.apply(snapshot, animatingDifferences: animate, completion: nil)
    }
    
    private func configureSections(with dataArray: [DataModel], and dictionary: inout [String: [DataModel]]) {
        for data in dataArray.sorted(by: { $0 < $1 }) {
            let key = data.header
            if dictionary[key] == nil {
                dictionary[key] = []
            }

            dictionary[key]?.append(data)
        }
    }
    
    // MARK: - Selectors
    @objc func addButtonTapped() {
//        let data: DataProtocol
//        switch self.activeData {
//        case .students: data = Student()
//        case .options: data = Option()
//        case .events: data = Event()
//        case .contacts: data = Contact()
//        case .none: return
//        }
//
//        presentDataEditingVC(with: data, editing: false, delegate: self)
    }
}

// MARK: - Delegates
extension DataListViewController: DataEditingDelegate {
    func reload(with model: DataModel) {
        let snapshot = self.dataSource.snapshot()
        
        // item exists in another section, delete it from dictionary
        if let item = snapshot.itemIdentifiers.first(where: { $0.id == model.id }) {
            if let items = self.studentSectionDictionary[item.header] {
                self.studentSectionDictionary[item.header] = items.filter( { $0 != item })

                if self.studentSectionDictionary[item.header]!.isEmpty {
                    self.studentSectionDictionary.removeValue(forKey: item.header)
                }
            }
        }
        
        // add item to correct section in dictionary
        if var items = self.studentSectionDictionary[model.header] {
            let index = items.getInsertionIndex(of: model)
            items.insert(model, at: index)
            self.studentSectionDictionary[model.header] = items
        } else {
            self.studentSectionDictionary[model.header] = [model]
        }

        // delete and append both sections
        applyListSnapshot(with: self.studentSectionDictionary, animate: true)
        
        
//        snapshot.appendItems(self.studentSectionDictionary[model.header]!, toSection: model.header)
//
//        self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        
//        var snapshot = self.dataSource.snapshot()
//        guard let item = snapshot.itemIdentifiers.first(where: { $0.id == data.id }) else { return }
//        let oldSection = item.header, newSection = data.header
//
//        item.row = data.row
//        item.header = data.header
//        item.set(data: data)
//        snapshot.reloadItems([item])
        
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
//        if oldSection != newSection {
//            if var items = self.studentSectionDictionary[newSection] {
//                let index = items.getInsertionIndex(of: item)
//                items.insert(item, at: index)
//                self.studentSectionDictionary[newSection] = items
//                snapshot.appendItems(items, toSection: newSection)
//
//                if let oldItems = self.studentSectionDictionary[oldSection] {
//                    self.studentSectionDictionary[oldSection] = oldItems.filter { $0 != item }
//                    snapshot.appendItems(self.studentSectionDictionary[oldSection]!, toSection: oldSection)
//                    if self.studentSectionDictionary[oldSection]!.isEmpty {
//                        print("empty")
//                        snapshot.deleteSections([oldSection])
//                    }
//                }
//                
//            } else {
//                self.studentSectionDictionary[newSection] = []
//            }
//            
//            didSelectDataItem(item)
//        }
//        
//        self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
//        
        let indexPath = self.dataSource.indexPath(for: model)
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
    }
}

extension DataListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let listItem = self.dataSource.itemIdentifier(for: indexPath) else { return }
        
        let detailVC = DataDetailViewController(model: listItem, delegate: self)
        let navController = UINavigationController(rootViewController: detailVC)
        showDetailViewController(navController, sender: self)
    }
}

class ListDataSource: UITableViewDiffableDataSource<String, DataModel> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let item = itemIdentifier(for: IndexPath(row: 0, section: section)) else { return nil
        }
        return item.header
//        return "data-source-error"
    }
}
