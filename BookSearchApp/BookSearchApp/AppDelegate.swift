//
//  AppDelegate.swift
//  BookSearchApp
//
//  Created by 윤주형 on 5/11/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().tintColor = .black
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: TabBarViewController())
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

