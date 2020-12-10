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
    var studentSectionDictionary: [StudentsSection: [Student]] = [StudentsSection: [Student]]()
    
    
    private var activeCollectionView: DataCollectionView! {
        didSet {
            activeCollectionView.removeFromSuperview()
            self.view.addSubview(activeCollectionView)
        }
    }
    private lazy var studentsCollectionView: StudentsCollectionView = {
        return StudentsCollectionView(frame: self.view.bounds, collectionViewLayout: UIHelper.createDataLayout(), sectionDictionary: self.studentSectionDictionary)
    }()
//    private lazy var majorsCollectionView: MajorsCollectionView = {
//        return MajorsCollectionView(frame: self.view.bounds, collectionViewLayout: UIHelper.createDataLayout(), data: self.majors)
//    }()
    
    // MARK: - View Controller Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        fetchData()
    }
    
    // MARK: - Configuration Functions
    private func configureView() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.tintColor = .systemTeal
    }
    
    // MARK: - Functions
    public func show(_ data: SEESData) {
        switch data {
        case .students: self.activeCollectionView = self.studentsCollectionView
        case .majors: ()
        case .events: ()
        case .contacts: ()
        }
    }
    
    private func fetchData() {
        self.networkManager.fetchData { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let dataDictionary):
                self.configure(studentData: dataDictionary[.students] as! [Student])
//                self.students = dataDictionary[.students] as! [Student]; self.configure(studentData: self.students)
//                self.majors = dataDictionary[.majors] as! [Major]
//                self.events = dataDictionary[.events] as! [Event]
//                self.contacts = dataDictionary[.contacts] as! [Contact]
            case .failure(let error): print(error)
            }
        }
    }
    
    private func configure(studentData: [Student]) {
        let sortedStudents = studentData.sorted { $0.lastName < $1.lastName }
        
        for student in sortedStudents {
            let letter = String(student.lastName.first!)
            let key = StudentsSection(rawValue: letter)!
            
            if var array = self.studentSectionDictionary[key] {
                array.append(student)
            } else {
                self.studentSectionDictionary[key] = []
                self.studentSectionDictionary[key]?.append(student)
            }
        }
    }
}

extension ListViewController: UICollectionViewDelegate {
    
}
