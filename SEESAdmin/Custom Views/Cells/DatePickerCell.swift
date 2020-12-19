//
//  DatePickerCell.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/18/20.
//

import UIKit

class DatePickerCell: UITableViewCell {
    private let datePicker = UIDatePicker()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(datePicker)
        datePicker.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: nil, paddingTop: 0, paddingLeft: 17, paddingBottom: 0, paddingRight: 0, width: 0, height: frame.height)
    }
    
    public func set(date: Date, tag: Int, target: Any, action: Selector) {
        self.datePicker.date = date
        self.datePicker.tag = tag
        self.datePicker.addTarget(target, action: action, for: .allEvents)
    }
}