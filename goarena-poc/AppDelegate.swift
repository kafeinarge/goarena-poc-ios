//
//  AppDelegate.swift
//  goarena-poc
//
//  Created by serhat akalin on 27.01.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SessionManager.shared.startSession()
        return true
    }
}

