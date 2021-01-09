//
//  UIViewControllerExt.swift
//  SEES
//
//  Created by Robert Parsons on 11/15/20.
//

import UIKit

fileprivate var containerView: UIView?

extension UIViewController {
    func presentErrorOnMainThread(withError error: SEESError, optionalMessage message: String? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: error.info.title, message: error.info.message + (message ?? ""), preferredStyle: .alert)
            alertController.view.tintColor = .systemTeal
            alertController.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alertController, animated: true)
        }
    }
    
    func presentAlertOnMainThread(withTitle title: String, andMessage message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.view.tintColor = .systemTeal
            alertController.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alertController, animated: true)
        }
    }
    
    func showLoadingViewOnMainThread() {
        DispatchQueue.main.async {
            containerView = UIView()
            containerView?.backgroundColor = .systemBackground
            containerView?.alpha = 0
            
            self.view.addSubview(containerView!)
            containerView?.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, x: self.view.centerXAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            UIView.animate(withDuration: 0.25) { containerView?.alpha = 0.8 }
            
            let activityIndicator = UIActivityIndicatorView(style: .large)
            containerView?.addSubview(activityIndicator)
            activityIndicator.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, x: containerView?.centerXAnchor, y: containerView?.centerYAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            
            activityIndicator.startAnimating()
        }
    }
    
    func dismissLoadingViewOnMainThread() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                containerView?.removeFromSuperview()
            }
            containerView = nil
        }
    }
    
    func presentDataEditingVC(with model: DataModel, delegate: DataEditingDelegate) {
        let navController = UINavigationController(rootViewController: DataEditingViewController(model: model, delegate: delegate))
        present(navController, animated: true)
    }
    
    func presentEmptyDataEditingVC(ofType type: FBDataType, delegate: DataEditingDelegate) {
        let navController = UINavigationController(rootViewController: DataEditingViewController(type: type, delegate: delegate))
        present(navController, animated: true)
    }
}
