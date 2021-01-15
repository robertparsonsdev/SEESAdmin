//
//  MajorTableViewController.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 1/14/21.
//

import UIKit

class MajorTableViewController: UITableViewController {
    private let cellID = "MajorSelectionCellID"
    
    private let majors = FBMajor.allCases
    private let delegate: MajorTableDelegate
    
    // MARK: - Initializers
    init(delegate: MajorTableDelegate) {
        self.delegate = delegate

        super.init(style: .plain)
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.majors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        cell.textLabel?.text = self.majors[indexPath.row].rawValue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.rowTapped(for: self.majors[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Configuration Functions
    func configureTableView() {
        self.title = "Available Majors"
        self.tableView.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.tintColor = .systemTeal
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
    }
}

protocol MajorTableDelegate {
    func rowTapped(for major: FBMajor)
}
