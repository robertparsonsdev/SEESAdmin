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
        
        let sections = Array(dictionary.keys).sorted(by: { $0 < $1 })
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
            
            snapshot.reinsert(section: newSection, with: existingSectionItems)
        } else {
            dictionary[newSection] = [model]
            snapshot.insertSectionInOrder(newSection, with: [model])
        }
    }
    
    private func applyReload(with snapshot: ListSnapshot, and model: DataModel) {
        self.dataSource.apply(snapshot, animatingDifferences: true, completion: {
            DispatchQueue.main.async {
                self.dataSource.apply(snapshot, animatingDifferences: false)
                
                if let indexPath = self.dataSource.indexPath(for: model) {
                    self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
                }
            }
        })
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
        applyReload(with: snapshot, and: model)
        saveDictionary(tempDictionary, for: model.type)
        
        pushDetailVC(with: model)
    }
    
    func reloadList(with model: DataModel, forOldSection oldSection: String) {
        var snapshot = self.dataSource.snapshot()
        var tempDictionary = getDictionary(for: model.type)
        
        if delete(modelID: model.id, fromSection: oldSection, withDictionary: &tempDictionary, andSnapshot: &snapshot) {
            insert(model: model, intoSection: model.section, withDictionary: &tempDictionary, andSnapshot: &snapshot)
            applyReload(with: snapshot, and: model)
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
        let detailVC = DataDetailViewController(model: model, listDelegate: self)
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
    func add(model: DataModel)
}
