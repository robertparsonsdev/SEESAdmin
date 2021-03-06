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
    private var selectedModel: DataModel?
    
    private var tableView: UITableView!
    private var dataSource: ListDataSource!
    typealias ListSnapshot = NSDiffableDataSourceSnapshot<String, DataModel>
    
    private var activeType: FBDataType! {
        didSet {
            guard activeType != oldValue else { return }
            
            switch activeType {
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
    public func show(_ type: FBDataType) {
        self.activeType = type
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
                DispatchQueue.main.async { self.activeType = .students }
                
            case .failure(let error):
                self.presentErrorOnMainThread(withError: .unableToFetchData, optionalMessage: "\n\n\(error.localizedDescription)")
            }
            
            self.dismissLoadingViewOnMainThread()
        }
    }
    
    private func applyListSnapshot(with dictionary: [String: [DataModel]], animate: Bool) {
        var snapshot = ListSnapshot()
        let sections: [String]
        
        switch self.activeType {
        case .events:
            sections = Array(dictionary.keys).sorted(by: { $0.convertToMonthYear() < $1.convertToMonthYear() })
        default:
            sections = Array(dictionary.keys).sorted(by: { $0 < $1 })
        }
        
        snapshot.appendSections(sections)

        for section in sections {
            if let models = dictionary[section] {
                snapshot.appendItems(models, toSection: section)
            }
        }

        self.dataSource.apply(snapshot, animatingDifferences: animate, completion: nil)
    }
    
    private func configureSections(with models: [DataModel], and dictionary: inout [String: [DataModel]]) {
        for model in models.sorted(by: { $0 < $1 }) {
            let key = model.section
            if dictionary[key] == nil {
                dictionary[key] = []
            }

            dictionary[key]?.append(model)
        }
    }
    
    private func delete(modelID id: String, fromSection oldSection: String, withDictionary dictionary: inout [String: [DataModel]], andSnapshot snapshot: inout ListSnapshot) -> Bool {
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
    
    private func insert(model: DataModel, intoSection newSection: String, withDictionary dictionary: inout [String: [DataModel]], andSnapshot snapshot: inout ListSnapshot) {
        if var existingSectionItems = dictionary[newSection] {
            let insertionIndex = existingSectionItems.getInsertionIndex(of: model)
            existingSectionItems.insert(model, at: insertionIndex)
            dictionary[newSection] = existingSectionItems
            
            snapshot.reinsert(section: newSection, with: existingSectionItems, for: model.type)
        } else {
            dictionary[newSection] = [model]
            snapshot.insertSectionInOrder(newSection, with: [model], for: model.type)
        }
    }
    
    private func applyReloadOnMainThread(with snapshot: ListSnapshot, and model: DataModel, animated: Bool) {
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: animated, completion: {
                DispatchQueue.main.async {
                    self.dataSource.apply(snapshot, animatingDifferences: false)
                    
                    if let indexPath = self.dataSource.indexPath(for: model) {
                        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
                    }
                }
            })
        }
    }
    
    private func getDictionary(for type: FBDataType) -> [String: [DataModel]] {
        switch type {
        case .students: return self.studentSectionDictionary
        case .options: return self.optionSectionDictionary
        case .events: return self.eventSectionDictionary
        case .contacts: return self.contactSectionDictionary
        }
    }
    
    private func saveDictionary(_ dictionary: [String: [DataModel]], for type: FBDataType) {
        switch type {
        case .students: self.studentSectionDictionary = dictionary
        case .options: self.optionSectionDictionary = dictionary
        case .events: self.eventSectionDictionary = dictionary
        case .contacts: self.contactSectionDictionary = dictionary
        }
    }
    
    // MARK: - Selectors
    @objc func addButtonTapped() {
        presentEmptyDataEditingVC(ofType: self.activeType, delegate: self)
    }
}

// MARK: - Delegates
extension DataListViewController: DataListDelegate {
    func add(model: DataModel) {
        var snapshot = self.dataSource.snapshot()
        var tempDictionary = getDictionary(for: model.type)
        
        insert(model: model, intoSection: model.section, withDictionary: &tempDictionary, andSnapshot: &snapshot)
        applyReloadOnMainThread(with: snapshot, and: model, animated: true)
        saveDictionary(tempDictionary, for: model.type)
        
        pushDetailVC(with: model)
    }
    
    func reloadList(with model: DataModel, forOldSection oldSection: String) {
        var snapshot = self.dataSource.snapshot()
        var tempDictionary = getDictionary(for: model.type)
        
        if delete(modelID: model.id, fromSection: oldSection, withDictionary: &tempDictionary, andSnapshot: &snapshot) {
            insert(model: model, intoSection: model.section, withDictionary: &tempDictionary, andSnapshot: &snapshot)
            applyReloadOnMainThread(with: snapshot, and: model, animated: true)
            saveDictionary(tempDictionary, for: model.type)
        }
    }
    
    func replace(model: DataModel) {
        let section = model.section
        var tempDictionary = getDictionary(for: model.type)
        var snapshot = self.dataSource.snapshot()
        
        if delete(modelID: model.id, fromSection: section, withDictionary: &tempDictionary, andSnapshot: &snapshot) {
            insert(model: model, intoSection: section, withDictionary: &tempDictionary, andSnapshot: &snapshot)
            applyReloadOnMainThread(with: snapshot, and: model, animated: false)
            saveDictionary(tempDictionary, for: model.type)
        }
    }
}

extension DataListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = self.dataSource.itemIdentifier(for: indexPath) else { return }
        
        pushDetailVC(with: model)
    }
    
    private func pushDetailVC(with model: DataModel) {
        self.selectedModel = model
        let detailVC = DataDetailViewController(model: model, listDelegate: self)
        let navController = UINavigationController(rootViewController: detailVC)
        showDetailViewController(navController, sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
            guard let self = self else { return }
            guard let model = self.dataSource.itemIdentifier(for: indexPath) else { self.presentErrorOnMainThread(withError: .unableToDelete); completion(false); return }
            
            let alert = UIAlertController(title: "Delete data?", message: "Are you sure you want to permanently delete this data?", preferredStyle: .alert)
            alert.view.tintColor = .systemTeal
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                completion(false)
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self, model, completion] (action) in
                guard let self = self else { return }
                
                self.networkManager.deleteData(at: model.path)
                var snapshot = self.dataSource.snapshot()
                var tempDictionary = self.getDictionary(for: model.type)
                
                if self.delete(modelID: model.id, fromSection: model.section, withDictionary: &tempDictionary, andSnapshot: &snapshot) {
                    self.applyReloadOnMainThread(with: snapshot, and: model, animated: true)
                    self.saveDictionary(tempDictionary, for: model.type)
                    
                    if self.selectedModel == model {
                        DispatchQueue.main.async {
                            self.showDetailViewController(EmptyStateVC(), sender: self)
                        }
                    } else {
                        DispatchQueue.main.async {
                            #warning("not working")
                            if let selectedModel = self.selectedModel, let indexPath = self.dataSource.indexPath(for: selectedModel) {
                                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
                            }
                        }
                    }
                    completion(true)
                } else {
                    completion(false)
                }
            }))
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

class ListDataSource: UITableViewDiffableDataSource<String, DataModel> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let item = itemIdentifier(for: IndexPath(row: 0, section: section)) else { return nil }
        return item.section
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - Protocols
protocol DataListDelegate {
    func reloadList(with model: DataModel, forOldSection oldSection: String)
    func add(model: DataModel)
    func replace(model: DataModel)
}
