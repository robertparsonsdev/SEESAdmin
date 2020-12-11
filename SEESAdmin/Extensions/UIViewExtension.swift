//
//  UIViewExtension.swift
//  SEES
//
//  Created by Robert Parsons on 11/13/20.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, x: NSLayoutXAxisAnchor? = nil, y: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top { self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true }
        if let leading = leading { self.leadingAnchor.constraint(equalTo: leading, constant: paddingLeft).isActive = true }
        if let bottom = bottom { self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true }
        if let trailing = trailing { self.trailingAnchor.constraint(equalTo: trailing, constant: -paddingRight).isActive = true }
        if let x = x { self.centerXAnchor.constraint(equalTo: x).isActive = true }
        if let y = y { self.centerYAnchor.constraint(equalTo: y).isActive = true }
        if width != 0 { self.widthAnchor.constraint(equalToConstant: width).isActive = true }
        if height != 0 { self.heightAnchor.constraint(equalToConstant: height).isActive = true }
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
