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
    func reload(model: DataModel) { // (with newModel: DataModel, id: String, oldSection: String?, newSection: String)
        var snapshot = self.dataSource.snapshot()
        snapshot.insertAndReload(model: model)
        
        self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        
        if let indexPath = self.dataSource.indexPath(for: model) {
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        }
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
        guard let item = itemIdentifier(for: IndexPath(row: 0, section: section)) else { return nil }
        return item.header
    }
}
