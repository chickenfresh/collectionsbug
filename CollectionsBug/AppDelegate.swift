//
//  AppDelegate.swift
//  CollectionsBug
//
//  Created by vladislav on 19.08.2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var mainWindow: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let mainView = UINavigationController(rootViewController: ViewController())
        mainWindow = UIWindow(frame: UIScreen.main.bounds)
        mainWindow?.rootViewController = mainView
        mainWindow?.makeKeyAndVisible()
        return true
    }
}

