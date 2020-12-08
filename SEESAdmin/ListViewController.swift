//
//  ViewController.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/6/20.
//

import UIKit

class ListViewController: UIViewController {
    static let storyboardID = "ListViewControllerID"
    static func instantiateFromStoryboard() -> ListViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(identifier: storyboardID) as? ListViewController
    }
    
    private let networkManager = NetworkManager.shared
    private var activeData: SEESData = .students
    private var students: [Student] = []
    private var majors: [Major] = []
    private var events: [Event] = []
    private var contacts: [Contact] = []
    
    // MARK: - View Controller Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        
        fetchData()
    }
    
    // MARK: - Configuration Functions
    private func configureViewController() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.tintColor = .systemTeal
    }
    
    // MARK: - Functions
    public func show(_ color: UIColor) {
        self.view.backgroundColor = color
    }
    
    private func fetchData() {
        self.networkManager.fetchData { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let dataDictionary):
                self.students = dataDictionary[.students] as! [Student]
                self.majors = dataDictionary[.majors] as! [Major]
                self.events = dataDictionary[.events] as! [Event]
                self.contacts = dataDictionary[.contacts] as! [Contact]
            case .failure(let error): print(error)
            }
        }
    }
}
