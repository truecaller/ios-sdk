//
//  AppDelegate.swift
//  SwiftTrueSDKHost
//
//  Created by Aleksandar Mihailovski on 16/12/16.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

import UIKit
import TrueSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Setup TrueSDK
        /*
         IMPORTANT!!!
         SET THE APP_LINK VALUE IN THE ENTITLEMENTS FILE AS WELL!!!
         UPDATE THE APPID (BUNDLE IDENTIFIER) IN YOUR PROJECT SETTINGS!!!
         */
        let appKey = Bundle.main.infoDictionary?["APP_KEY"] as? String ?? ""
        let appLink = Bundle.main.infoDictionary?["APP_LINK"] as? String ?? ""
        
        TCTrueSDK.sharedManager().setup(withAppKey: appKey, appLink: appLink)
        
        return true
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
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return TCTrueSDK.sharedManager().application(application, continue: userActivity, restorationHandler: restorationHandler as? ([Any]?) -> Void)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return TCTrueSDK.sharedManager().continue(withUrlScheme: url)
    }
}

