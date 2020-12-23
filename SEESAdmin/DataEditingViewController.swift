//
//  DataEditingViewController.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/16/20.
//

import UIKit

class DataEditingViewController: UITableViewController {
    private let textFieldCellID = "TextFieldCellID"
    private let dataPickerCellID = "DatePickerCellID"
    
    private let data: DataProtocol
    private var editsDictionary: [String: Any] = [:]
    private let editMode: Bool
    
    // MARK: - Initializers
    init(data: DataProtocol, editing: Bool) {
        self.data = data
        self.editMode = editing
        
        for item in data.tableItems {
            self.editsDictionary[item.headerTitle] = item.itemTitle
        }
        
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
        return self.data.tableItems[section].headerTitle
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.data.tableItems[indexPath.section]
        let itemText = self.editsDictionary[item.headerTitle] as? String ?? ""
        
        switch item.editableView {
        case .textField:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.textFieldCellID, for: indexPath) as! TextFieldCell
            cell.set(text: itemText, tag: indexPath.section, target: self, action: #selector(textFieldChanged))
            return cell
        case .datePicker:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.dataPickerCellID, for: indexPath) as! DatePickerCell
            cell.set(date: itemText.convertToDate(), tag: indexPath.section, target: self, action: #selector(datePickerChanged))
            return cell
        }
    }
    
    // MARK: - Configuration Functions
    private func configureTableView() {
        self.tableView.backgroundColor = .systemBackground
        self.tableView.register(TextFieldCell.self, forCellReuseIdentifier: self.textFieldCellID)
        self.tableView.register(DatePickerCell.self, forCellReuseIdentifier: self.dataPickerCellID)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = .systemRed
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
        saveButton.tintColor = .systemTeal
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        
        switch data.dataCase {
        case .students: title = editMode ? "Edit Student" : "New Student"
        case .options: title = editMode ? "Edit Option" : "New Option"
        case .events: title = editMode ? "Edit Event" : "New Event"
        case .contacts: title = editMode ? "Edit Contact" : "New Contact"
        }
    }
    
    // MARK: - Selectors
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        if let error = ValidationChecker.validateText(of: self.editsDictionary, for: self.data.dataCase) {
            presentErrorOnMainThread(withError: error)
            return
        }
        
        NetworkManager.shared.updateData(at: self.data.path, with: self.editsDictionary) { [weak self] (error) in
            guard let self = self else { return }
            guard error == nil else { self.presentErrorOnMainThread(withError: error!); return }
                
            print("updated")
        }
    }
    
    @objc private func textFieldChanged(textField: UITextField) {
        let key = self.data.tableItems[textField.tag].headerTitle
        self.editsDictionary[key] = textField.text
    }
    
    @objc private func datePickerChanged(datePicker: UIDatePicker) {
        let dateString = datePicker.date.convertToString()
        let key = self.data.tableItems[datePicker.tag].headerTitle
        self.editsDictionary[key] = dateString
    }
}
