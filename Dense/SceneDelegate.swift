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
    let useSwiftUI = false

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = rootViewController()
            window.makeKeyAndVisible()
            
            self.window = window
        }
    }
    
    func rootViewController() -> UIViewController? {
        if useSwiftUI {
            return UIHostingController(rootView: FoodListView())
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            return storyboard.instantiateInitialViewController()
        }
    }
}
