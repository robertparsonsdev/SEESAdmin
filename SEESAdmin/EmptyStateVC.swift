//
//  EmptyStateVC.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 1/2/21.
//

import UIKit

class EmptyStateVC: UIViewController {
    private let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isUserInteractionEnabled = false
        configureLabel()
    }

    private func configureLabel() {
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.text = "Select a row of data to display here."
        
        self.view.addSubview(label)
        label.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
