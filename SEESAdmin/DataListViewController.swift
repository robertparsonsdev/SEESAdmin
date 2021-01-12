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
    typealias ListSnapshot = NSDiffableDataSourceSnapshot<String, DataModel>
    
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
        var snapshot = ListSnapshot()
        
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
            let key = data.section
            if dictionary[key] == nil {
                dictionary[key] = []
            }

            dictionary[key]?.append(data)
        }
    }
    
    func delete(modelID id: String, fromSection oldSection: String, withDictionary dictionary: inout [String: [DataModel]], andSnapshot snapshot: inout ListSnapshot) -> Bool {
        guard var oldSectionItems = dictionary[oldSection],
              let deletionIndex = oldSectionItems.firstIndex(where: { $0.id == id }),
              let oldModel = oldSectionItems.getItemAt(deletionIndex)
        else { presentErrorOnMainThread(withError: .unableToReloadList); return false }
        
        oldSectionItems.remove(at: deletionIndex)
        snapshot.deleteItems([oldModel])
        
        if oldSectionItems.isEmpty {
            dictionary.removeValue(forKey: oldSection)
            snapshot.deleteSections([oldSection])
        } else {
            dictionary[oldSection] = oldSectionItems
        }
        
        return true
    }
    
    func insert(model: DataModel, intoSection newSection: String, withDictionary dictionary: inout [String: [DataModel]], andSnapshot snapshot: inout ListSnapshot) {
        if var existingSectionItems = dictionary[newSection] {
            let insertionIndex = existingSectionItems.getInsertionIndex(of: model)
            existingSectionItems.insert(model, at: insertionIndex)
            dictionary[newSection] = existingSectionItems
            
            snapshot.reinsert(section: newSection, with: existingSectionItems)
        } else {
            dictionary[newSection] = [model]
            snapshot.insertSectionInOrder(newSection, with: [model])
        }
    }
    
    func applyReload(with snapshot: ListSnapshot, and model: DataModel) {
        self.dataSource.apply(snapshot, animatingDifferences: true, completion: {
            DispatchQueue.main.async {
                self.dataSource.apply(snapshot, animatingDifferences: false)
                if let indexPath = self.dataSource.indexPath(for: model) {
                    self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                }
            }
        })
    }
    
    // MARK: - Selectors
    @objc func addButtonTapped() {
        presentEmptyDataEditingVC(ofType: self.activeData, delegate: self)
    }
}

// MARK: - Delegates
extension DataListViewController: DataListDelegate {
    func reloadList(with model: DataModel, forOldSection oldSection: String) {
        var snapshot = self.dataSource.snapshot()
        var tempDictionary: [String: [DataModel]]
        
        switch self.activeData {
        case .students: tempDictionary = self.studentSectionDictionary
        case .options: tempDictionary = self.optionSectionDictionary
        case .events: tempDictionary = self.eventSectionDictionary
        case .contacts: tempDictionary = self.contactSectionDictionary
        case .none: presentErrorOnMainThread(withError: .unableToReloadList); return
        }
        
        if delete(modelID: model.id, fromSection: oldSection, withDictionary: &tempDictionary, andSnapshot: &snapshot) {
            insert(model: model, intoSection: model.section, withDictionary: &tempDictionary, andSnapshot: &snapshot)
            applyReload(with: snapshot, and: model)
        }
        
        switch self.activeData {
        case .students: self.studentSectionDictionary = tempDictionary
        case .options: self.optionSectionDictionary = tempDictionary
        case .events: self.eventSectionDictionary = tempDictionary
        case .contacts: self.contactSectionDictionary = tempDictionary
        case .none: presentErrorOnMainThread(withError: .unableToReloadList); return
        }
    }
}

extension DataListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let listItem = self.dataSource.itemIdentifier(for: indexPath) else { return }
        
        let detailVC = DataDetailViewController(model: listItem, listDelegate: self)
        let navController = UINavigationController(rootViewController: detailVC)
        showDetailViewController(navController, sender: self)
    }
}

class ListDataSource: UITableViewDiffableDataSource<String, DataModel> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let item = itemIdentifier(for: IndexPath(row: 0, section: section)) else { return nil }
        return item.section
    }
}

// MARK: - Protocols
protocol DataListDelegate {
    func reloadList(with model: DataModel, forOldSection oldSection: String)
}
