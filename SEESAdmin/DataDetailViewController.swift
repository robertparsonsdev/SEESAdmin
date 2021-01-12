//
//  DataDetailViewController.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/6/20.
//

import UIKit

class DataDetailViewController: UITableViewController {
    private let cellID = "DataDetailCellID"
    private var model: DataModel
    private var tableItems: [TableItem]
    private let delegate: DataEditingDelegate
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: DataModel, delegate: DataEditingDelegate) {
        self.model = model
        self.tableItems = model.tableItems
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
        cell.selectionStyle = .none

        cell.textLabel?.text = self.tableItems[indexPath.section].row
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableItems[section].header
    }
    
    // MARK: - Configuration Functions
    private func configureTableView() {
        self.title = self.model.row
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        editButton.tintColor = .systemTeal
        self.navigationItem.rightBarButtonItem = editButton
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
    }
    
    // MARK: - Selectors
    @objc func editButtonTapped() {
        presentDataEditingVC(with: self.model, delegate: self)
    }
}

// MARK: - Delegates
extension DataDetailViewController: DataEditingDelegate {
    func reload(model: DataModel) {
        self.delegate.reload(model: model)

        self.model = model
        self.tableItems = model.tableItems
        self.title = model.row
        self.tableView.reloadData()
    }
}
