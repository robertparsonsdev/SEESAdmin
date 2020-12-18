//
//  DataDetailViewController.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/6/20.
//

import UIKit

class DataDetailViewController: UITableViewController {
    private let cellID = "DataDetailCellID"
    private var data: DataProtocol?
    
    // MARK: - Initializers
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(data: DataProtocol) {
        self.init()
        self.data = data
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
        cell.textLabel?.text = self.data?.tableItems[indexPath.section].itemTitle
        cell.selectionStyle = .none
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.data?.tableItems.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.data?.tableItems[section].headerTitle
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
        let navController = UINavigationController(rootViewController: DataEditingViewController(data: self.data!, editing: true))
        present(navController, animated: true, completion: nil)
    }
}
