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
    private var detailItems: [DetailTableItem]
    private let delegate: DataEditingDelegate
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: DataModel, delegate: DataEditingDelegate) {
        self.model = model
        self.detailItems = model.detailItems
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

        cell.textLabel?.text = self.detailItems[indexPath.section].row
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.detailItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.detailItems[section].header
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
        presentDataEditingVC(with: self.model, editing: true, delegate: self)
    }
}

// MARK: - Delegates
extension DataDetailViewController: DataEditingDelegate {
    func reload(with newModel: DataModel) {
//        print("old:", self.model.row)
//        print("new:", newModel.row)
//        if self.model.row != newModel.row {
            self.delegate.reload(with: newModel)
//        }

//        self.model = newModel
        self.detailItems = self.model.detailItems
        self.title = self.model.row
        self.tableView.reloadData()
    }
}
