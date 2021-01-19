//
//  TimeRangeCell.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 1/18/21.
//

import UIKit

class TimeRangeCell: UITableViewCell {
    private var day: String!
    private var delegate: TimeRangeDelegate!
    
    private let toggle = UISwitch()
    private let startTimePicker = UIDatePicker()
    private let dashLabel = UILabel()
    private let endTimePicker = UIDatePicker()
    
    // MARK: - Iintializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configureation Functions
    private func configure() {
        self.selectionStyle = .none
        
        configureToggle()
        configurePickers()
        configureDashLabel()
        
        contentView.addSubviews(toggle, startTimePicker, dashLabel, endTimePicker)
        let internalPadding: CGFloat = 10, leading = contentView.leadingAnchor, y = contentView.centerYAnchor, height = frame.height
        
        toggle.anchor(top: nil, leading: leading, bottom: nil, trailing: nil, y: y, paddingTop: 0, paddingLeft: 17, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        startTimePicker.anchor(top: nil, leading: toggle.trailingAnchor, bottom: nil, trailing: nil, y: y, paddingTop: 0, paddingLeft: internalPadding * 2, paddingBottom: 0, paddingRight: 0, width: 0, height: height)
        dashLabel.anchor(top: nil, leading: startTimePicker.trailingAnchor, bottom: nil, trailing: nil, y: y, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: height)
        endTimePicker.anchor(top: nil, leading: dashLabel.trailingAnchor, bottom: nil, trailing: nil, y: y, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: height)
    }
    
    private func configureToggle() {
        toggle.onTintColor = .systemTeal
        toggle.addTarget(self, action: #selector(toggledTapped(_:)), for: .valueChanged)
    }
    
    private func configurePickers() {
        startTimePicker.datePickerMode = .time
        endTimePicker.datePickerMode = .time
        startTimePicker.preferredDatePickerStyle = .inline
        endTimePicker.preferredDatePickerStyle = .inline
        
        startTimePicker.addTarget(self, action: #selector(pickerChanged), for: .valueChanged)
        endTimePicker.addTarget(self, action: #selector(pickerChanged), for: .valueChanged)
    }
    
    @objc func test() {
        startTimePicker.becomeFirstResponder()
    }
    
    private func configureDashLabel() {
        dashLabel.text = "-"
    }

    // MARK: - Setters
    public func set(startTime: Date?, endTime: Date?, day: String, delegate: TimeRangeDelegate) {
        self.day = day
        self.delegate = delegate
        
        if let startTime = startTime, let endTime = endTime {
            self.startTimePicker.date = startTime
            self.endTimePicker.date = endTime
            showPickers(true)
            self.toggle.isOn = true
        } else {
            showPickers(false)
            self.toggle.isOn = false
        }
    }
    
    // MARK: - Functions
    private func showPickers(_ show: Bool) {
        self.startTimePicker.isHidden = !show
        self.dashLabel.isHidden = !show
        self.endTimePicker.isHidden = !show
        
        self.startTimePicker.isUserInteractionEnabled = show
        self.dashLabel.isUserInteractionEnabled = show
        self.endTimePicker.isUserInteractionEnabled = show
    }
    
    // MARK: - Selectors
    @objc private func toggledTapped(_ sender: UISwitch) {
        if sender.isOn {
            showPickers(true)
            self.delegate.rangeChanged(startTime: self.startTimePicker.date, endTime: self.endTimePicker.date, day: self.day)
        } else {
            showPickers(false)
            self.delegate.rangeChanged(startTime: nil, endTime: nil, day: self.day)
        }
    }
    
    @objc private func pickerChanged() {
        self.delegate.rangeChanged(startTime: self.startTimePicker.date, endTime: self.endTimePicker.date, day: self.day)
    }
}

// MARK: - Protocols
protocol TimeRangeDelegate {
    func rangeChanged(startTime: Date?, endTime: Date?, day: String)
}
