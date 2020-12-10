//
//  MajorsCollectionView.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/9/20.
//

import UIKit

class MajorsCollectionView: DataCollectionView {

    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, data: [DataProtocol]) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
