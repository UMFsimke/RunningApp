//
//  AppDelegate.swift
//  RunningApp
//
//  Created by Aleksandar Simic on 3/13/19.
//  Copyright © 2019 SimicAleksandar. All rights reserved.
//

import UIKit
import RunningAppServer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate lazy var coordinator = AppCoordinator()
    fileprivate var devServer: Server?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        switch Configuration.current {
        case .Release:
            break
        case .Test:
            runTestServer()
            setupTestEnvironment()
        }
        
        coordinator.start()
        return true
    }

}

fileprivate extension AppDelegate {
    
    func runTestServer() {
        devServer = try? Server.start()
    }
    
    func setupTestEnvironment() {
        
    }
}
