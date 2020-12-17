//
//  DataEditingViewController.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/16/20.
//

import UIKit

class DataEditingViewController: UITableViewController {
    private let cellID = "DataEditingCellID"
    private let data: DataProtocol
    private let editMode: Bool
    
    // MARK: - Initializers
    init(data: DataProtocol, editing: Bool) {
        self.data = data
        self.editMode = editing
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.tableItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.data.tableItems[section].section
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let textField = UITextField()
        textField.clearButtonMode = .whileEditing
        textField.text = self.data.tableItems[indexPath.section].value
        cell.contentView.addSubview(textField)
        textField.anchor(top: cell.contentView.topAnchor, leading: cell.contentView.leadingAnchor, bottom: nil, trailing: cell.contentView.trailingAnchor, paddingTop: 0, paddingLeft: 17, paddingBottom: 0, paddingRight: 17, width: 0, height: cell.frame.height)
        return cell
    }
    
    // MARK: - Configuration Functions
    private func configureTableView() {
        self.tableView.backgroundColor = .systemBackground
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = .systemRed
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
        saveButton.tintColor = .systemTeal
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        
        switch data {
        case is Student: title = editMode ? "Edit Student" : "New Student"
        case is Option: title = editMode ? "Edit Option" : "New Option"
        case is Event: title = editMode ? "Edit Event" : "New Event"
        case is Contact: title = editMode ? "Edit Contact" : "New Contact"
        default: break
        }
    }
    
    // MARK: - Selectors
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        showLoadingView()
    }
}