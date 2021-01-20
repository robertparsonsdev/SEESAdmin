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
        selectionStyle = .none

        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        
        self.textLabel?.removeFromSuperview()
        self.detailTextLabel?.removeFromSuperview()
        
        contentView.addSubview(textField)
        textField.anchor(top: nil, leading: contentView.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: contentView.layoutMarginsGuide.trailingAnchor, y: contentView.centerYAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    public func set(text: String, tag: Int, target: Any, action: Selector, firstResponder: Bool) {
        self.textField.text = text
        self.textField.tag = tag
        self.textField.addTarget(target, action: action, for: .allEditingEvents)
        if firstResponder {
            self.textField.becomeFirstResponder()
        }
    }
}
