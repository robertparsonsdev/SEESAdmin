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
    
    private var model: DataModel?
    private let modelType: FBDataType
    private var editsDictionary: [String: Any] = [:]
    private let oldRow: String
    private let oldSection: String

    private let tableItems: [TableItem]
    private let editMode: Bool
    private var detailDelegate: DataDetailDelegate?
    private let listDelegate: DataListDelegate
    
    private lazy var updateButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Update Data", style: .done, target: self, action: #selector(updateButtonTapped))
        button.tintColor = .systemTeal
        return button
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Add Data", style: .done, target: self, action: #selector(addButtonTapped))
        button.tintColor = .systemTeal
        return button
    }()
    
    // MARK: - Initializers
    // for reloading
    init(model: DataModel, detailDelegate: DataDetailDelegate, listDelegate: DataListDelegate) {
        self.model = model
        self.modelType = model.type
        self.editsDictionary = model.data
        self.oldRow = model.row
        self.oldSection = model.section

        self.tableItems = model.tableItems
        self.editMode = true
        
        self.detailDelegate = detailDelegate
        self.listDelegate = listDelegate

        super.init(style: .insetGrouped)
    }
    
    // for adding
    init(type: FBDataType, listDelegate: DataListDelegate) {
        self.modelType = type
        self.oldRow = ""
        self.oldSection = ""
        
        switch type {
        case .students: self.editsDictionary = FBStudent.emptyKeys
        case .options: self.editsDictionary = FBOption.emptyKeys
        case .events: self.editsDictionary = FBEvent.emptyKeys
        case .contacts: self.editsDictionary = FBContact.emptyKeys
        }
        
        self.tableItems = TableItem.getItems(from: self.editsDictionary, for: type)
        self.editMode = false
        self.listDelegate = listDelegate
        
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table View Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableItems[section].header
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.tableItems[indexPath.section]
        let itemText = self.editsDictionary[item.header] as? String ?? ""

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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    // MARK: - Configuration Functions
    private func configureTableView() {
        self.tableView.backgroundColor = .systemBackground
        self.tableView.register(TextFieldCell.self, forCellReuseIdentifier: self.textFieldCellID)
        self.tableView.register(DatePickerCell.self, forCellReuseIdentifier: self.dataPickerCellID)

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = .systemRed

        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = self.editMode ? self.updateButton : self.addButton
        
        switch self.modelType {
        case .students: title = editMode ? "Edit Student" : "New Student"
        case .options: title = editMode ? "Edit Option" : "New Option"
        case .events: title = editMode ? "Edit Event" : "New Event"
        case .contacts: title = editMode ? "Edit Contact" : "New Contact"
        }
    }
    
    // MARK: - Functions
    private func updateFirebase(with model: DataModel) {
        showLoadingViewOnMainThread()
        NetworkManager.shared.updateData(at: model.path, with: model.data) { [weak self, model] (error) in
            guard let self = self else { return }
            self.dismissLoadingViewOnMainThread()
            guard error == nil else { self.presentErrorOnMainThread(withError: error!); return }

            self.dismissAndReloadOnMainThread(with: model)
        }
    }
    
    private func dismissAndReloadOnMainThread(with model: DataModel) {
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                if self.editMode {
                    self.detailDelegate?.reloadDetail(with: model)
                    if model.row != self.oldRow || model.section != self.oldSection {
                        self.listDelegate.reloadList(with: model, forOldSection: self.oldSection)
                    }
                } else {
                    self.listDelegate.add(model: model)
                }
            }
        }
    }
    
    private func validateEditsDictionary() -> Bool {
        if let error = ValidationChecker.validateText(of: self.editsDictionary, for: self.modelType) {
            presentErrorOnMainThread(withError: error)
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Selectors
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func updateButtonTapped() {
        guard validateEditsDictionary() else { return }
        
        if var model = self.model {
            model.data = self.editsDictionary
            updateFirebase(with: model)
        } else {
            presentErrorOnMainThread(withError: .unableToUpdateData(error: "Nil model in editing while updating."))
        }
    }
    
    @objc private func addButtonTapped() {
        guard validateEditsDictionary() else { return }

        let id: String
        switch self.modelType {
        case .students:
            if let email = self.editsDictionary[FBStudent.email.key] as? String {
                id = email.components(separatedBy: "@")[0]
            } else {
                presentErrorOnMainThread(withError: .unableToAddStudent(error: "Couldn't parse email."))
                return
            }
        default: id = UUID().uuidString
        }
        
        self.model = DataModel(id: id, data: self.editsDictionary, type: self.modelType)
        updateFirebase(with: self.model!)
    }
    
    @objc private func textFieldChanged(textField: UITextField) {
        let key = self.tableItems[textField.tag].header
        self.editsDictionary[key] = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    @objc private func datePickerChanged(datePicker: UIDatePicker) {
        let dateString = datePicker.date.convertToString()
        let key = self.tableItems[datePicker.tag].header
        self.editsDictionary[key] = dateString
    }
}
