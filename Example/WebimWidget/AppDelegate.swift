//
//  AppDelegate.swift
//  WebimWidget
//
//  Created by kotsan777 on 12/22/2022.
//  Copyright (c) 2022 kotsan777. All rights reserved.
//

import UIKit
import WebimWidget

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let widget = ExternalWidgetBuilder()
            .buildDefaultWidget(
                accontName: "wmtest105",
                location: "mobile"
            )
        let navigationController = UINavigationController(rootViewController: widget)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        WidgetAppDelegate.shared.applicationDidEnterBackground()
    }
}

