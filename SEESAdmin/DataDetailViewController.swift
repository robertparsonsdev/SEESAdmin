//
//  DataDetailViewController.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/6/20.
//

import UIKit

class DataDetailViewController: UITableViewController {
    private let cellID = "DataDetailCellID"
    private var data: DataProtocol
    private var tableItems: [DetailTableItem]
    private let delegate: DataEditingDelegate
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(data: DataProtocol, delegate: DataEditingDelegate) {
        self.data = data
        self.tableItems = data.detailItems
        self.delegate = delegate
        
        super.init(style: .insetGrouped)
    }
    
    // MARK: - Table View Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = self.tableItems[indexPath.section].itemTitle
        cell.selectionStyle = .none
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableItems.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableItems[section].headerTitle
    }
    
    // MARK: - Configuration Functions
    private func configureTableView() {
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        editButton.tintColor = .systemTeal
        self.navigationItem.rightBarButtonItem = editButton
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
    }
    
    // MARK: - Selectors
    @objc func editButtonTapped() {
        presentDataEditingVC(with: self.data, editing: true, delegate: self)
    }
}

// MARK: - Delegates
extension DataDetailViewController: DataEditingDelegate {
    func reload(with data: DataProtocol) {
        if self.data.listTitle != data.listTitle {
            self.delegate.reload(with: data)
        }
        
        self.data = data
        self.tableItems = data.detailItems
        self.tableView.reloadData()
    }
}
