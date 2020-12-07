//
//  ViewController.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/6/20.
//

import UIKit

class ViewController: UIViewController {
    static let storyboardID = "ViewControllerID"
    static func instantiateFromStoryboard() -> ViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(identifier: storyboardID) as? ViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
    }
    
    private func configureViewController() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.tintColor = .systemTeal
    }
}

