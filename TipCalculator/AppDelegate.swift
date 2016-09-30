//
//  AppDelegate.swift
//  TipCalculator
//
//  Created by James Zhou on 9/20/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let tipVC = TipViewController.init()
        let navVC = UINavigationController(rootViewController: tipVC)
        window?.rootViewController = navVC
        
        // user defaults
        let defaults = UserDefaults.standard
        let didLoadBefore = defaults.bool(forKey: "loaded")
        
        if (didLoadBefore != true) {
            defaults.set(true, forKey: "loaded")
            defaults.set(15, forKey: "default")
            defaults.set(10, forKey: "min")
            defaults.set(20, forKey: "max")
            defaults.set(true, forKey: "doubleTap")
            defaults.synchronize()
        }
        
        return true
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        var tipVC: UIViewController
        
        switch shortcutItem.type {
        case "trigger_percentage_10":
            tipVC = TipViewController.init(percentage: 0.10)
            break
        case "trigger_percentage_15":
            tipVC = TipViewController.init(percentage: 0.15)
            break
        case "trigger_percentage_20":
            tipVC = TipViewController.init(percentage: 0.20)
            break
        default:
            tipVC = TipViewController.init()
            break
        }
        let navVC = UINavigationController(rootViewController: tipVC)
        window?.rootViewController = navVC
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

