//
//  DataViewController.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/6/20.
//

import UIKit

class DataViewController: UIViewController {
    static let storyboardID = "ListViewControllerID"
    static func instantiateFromStoryboard() -> DataViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(identifier: storyboardID) as? DataViewController
    }
    
    private let networkManager = NetworkManager.shared
    private var studentSectionDictionary = [String: [Student]]()
    private var majorSectionDictionary = [String: [Option]]()
    private var eventSectionDictionary = [String: [Event]]()
    private var contactSectionDictionary = [String: [Contact]]()
    
    private var activeCollectionView: DataCollectionView? {
        didSet {
            activeCollectionView?.removeFromSuperview()
            self.view.addSubview(activeCollectionView!)
        }
    }
    private lazy var studentsCollectionView: StudentsCollectionView = {
        return StudentsCollectionView(frame: self.view.bounds, sectionDictionary: self.studentSectionDictionary, delegate: self)
    }()
    private lazy var majorsCollectionView: MajorsCollectionView = {
        return MajorsCollectionView(frame: self.view.bounds, sectionDictionary: self.majorSectionDictionary, delegate: self)
    }()
    private lazy var eventsCollectionView: EventsCollectionView = {
        return EventsCollectionView(frame: self.view.bounds, sectionDictionary: self.eventSectionDictionary, delegate: self)
    }()
    private lazy var contactsCollectionView: ContactsCollectionView = {
        return ContactsCollectionView(frame: self.view.bounds, sectionDictionary: self.contactSectionDictionary, delegate: self)
    }()
    
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
        case .majors: self.activeCollectionView = self.majorsCollectionView
        case .events: self.activeCollectionView = self.eventsCollectionView
        case .contacts: self.activeCollectionView = self.contactsCollectionView
        }
    }
    
    private func fetchData() {
        showLoadingView()
        self.networkManager.fetchData { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let dataDictionary):
                self.configure(studentData: dataDictionary[.students] as! [Student])
                self.configure(majorData: dataDictionary[.majors] as! [Major])
                self.configure(eventsData: dataDictionary[.events] as! [Event])
                self.configure(contactsData: dataDictionary[.contacts] as! [Contact])
            case .failure(let error):
                self.presentErrorOnMainThread(withError: .unableToFetchData, optionalMessage: "\n\n\(error.localizedDescription)")
            }
            self.dismissLoadingView()
        }
    }
    
    private func configure(studentData: [Student]) {
        for student in studentData {
            let letter = String(student.lastName.first ?? Character("error")).uppercased()
            
            if var array = self.studentSectionDictionary[letter] {
                array.append(student)
            } else {
                self.studentSectionDictionary[letter] = []
                self.studentSectionDictionary[letter]?.append(student)
            }
        }
    }
    
    private func configure(majorData: [Major]) {
        for major in majorData {
            let majorName = major.majorName.lowercased()
            
            if var array = self.majorSectionDictionary[majorName] {
                array.append(contentsOf: major.options)
            } else {
                self.majorSectionDictionary[majorName] = []
                self.majorSectionDictionary[majorName]?.append(contentsOf: major.options)
            }
        }
    }
    
    private func configure(eventsData: [Event]) {
        self.eventSectionDictionary[EventsSection.events.rawValue] = eventsData.sorted { $0.startDate < $1.startDate }
    }
    
    private func configure(contactsData: [Contact]) {
        self.contactSectionDictionary[ContactsSection.contacts.rawValue] = contactsData.sorted { $0.order < $1.order }
    }
}

extension DataViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let listItem = self.activeCollectionView?.diffableDataSource.itemIdentifier(for: indexPath) else { return }
        print(listItem.title)
    }
}
