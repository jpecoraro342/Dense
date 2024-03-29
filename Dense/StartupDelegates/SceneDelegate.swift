//
//  SceneDelegate.swift
//  Dense
//
//  Created by Joseph Pecoraro on 2/28/23.
//  Copyright © 2023 Joseph Pecoraro. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: NSObject, UISceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = rootViewController()
            window.makeKeyAndVisible()
            
            self.window = window
        }
        
        UserDefaults.standard.setDefaults()
        
        if UserDefaults.standard.bool(forKey: UserDefaults.analyticsEnabledKey) {
            Analytics.shared.start()
        }
    }
    
    func rootViewController() -> UIViewController? {
        return UIHostingController(rootView: CoordinatorView())
    }
}
