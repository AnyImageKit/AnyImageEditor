//
//  AppDelegate.swift
//  Example
//
//  Created by 蒋惠 on 2019/10/23.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        return true
    }
}

extension AppDelegate {
    
    private func setupWindow() {
        let windows = UIWindow(frame: UIScreen.main.bounds)
        let homeController = ConfigController(style: .plain)
        let navigationController = UINavigationController(rootViewController: homeController)
        windows.rootViewController = navigationController
        windows.makeKeyAndVisible()
        
        self.window = windows
    }
}
