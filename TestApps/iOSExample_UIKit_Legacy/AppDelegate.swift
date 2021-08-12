//
//  AppDelegate.swift
//  Created by Chris Mash on 12/03/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow()
        let viewController = ViewController(displayInfo: "iOS \(UIDevice.current.systemVersion), UIKit (no SceneDelegate)")
        window.rootViewController = viewController
         
        self.window = window
        window.makeKeyAndVisible()
        
        return true
    }

}
