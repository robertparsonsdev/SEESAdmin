//
//  SceneDelegate.swift
//  SEESAdmin
//
//  Created by Robert Parsons on 12/6/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        if self.window?.traitCollection.userInterfaceIdiom == .pad {
            if let splitVC = createThreeColumnSplitViewController() {
                window?.rootViewController = splitVC
            }
        }
    }
}

extension SceneDelegate {
    private func createThreeColumnSplitViewController() -> UISplitViewController? {
        guard let listVC = DataViewController.instantiateFromStoryboard() else { return nil }
        let sidebarVC = SidebarViewController()
        let detailVC = DetailViewController(style: .plain)
        
        let splitVC = UISplitViewController(style: .tripleColumn)
        splitVC.primaryBackgroundStyle = .sidebar
        splitVC.preferredDisplayMode = .twoBesideSecondary
        
        splitVC.setViewController(sidebarVC, for: .primary)
        splitVC.setViewController(listVC, for: .supplementary)
        splitVC.setViewController(detailVC, for: .secondary)
        
        return splitVC
    }
}
