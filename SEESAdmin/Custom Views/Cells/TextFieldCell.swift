//
//  TextFieldCell.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/18/20.
//

import UIKit

class TextFieldCell: UITableViewCell {
    private let textField = UITextField()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        textField.clearButtonMode = .whileEditing
        
        contentView.addSubview(textField)
        textField.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, paddingTop: 0, paddingLeft: 17, paddingBottom: 0, paddingRight: 17, width: 0, height: frame.height)
    }
    
    public func set(text: String, tag: Int, target: Any, action: Selector) {
        self.textField.text = text
        self.textField.tag = tag
        self.textField.addTarget(target, action: action, for: .editingChanged)
    }
}
