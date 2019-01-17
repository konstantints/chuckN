//
//  AppDelegate.swift
//  ChuckN
//
//  Created by Konstantin Tsistjakov on 16/01/2019.
//  Copyright © 2019 Chipp Studio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var network: Network!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UserDefaults.standard.register(defaults: ["dark": false])
       
        // Set network and initial categories update
        self.network = Network()
        
        // Set statup view controller
        self.window?.rootViewController = UIStoryboard(name: Storyboards.categories.rawValue, bundle: nil).instantiateInitialViewController()!
        self.window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: - App lifecicle
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
