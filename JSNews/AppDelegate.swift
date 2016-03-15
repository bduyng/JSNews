//
//  AppDelegate.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 1/12/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Material design :)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        let statusBarBackground = UIView(frame: statusBarFrame)
        statusBarBackground.backgroundColor = UIColor.darkPrimaryColor()
        self.window?.rootViewController?.view.addSubview(statusBarBackground)
        
        //
        window?.backgroundColor = UIColor.whiteColor()
        
        // Bar tint color
        UINavigationBar.appearance().barStyle = .Black
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = UIColor.primaryColor()
        
        
        // Switch tint color
        UISwitch.appearance().onTintColor = UIColor.primaryColor()
        
        // Simplest way to find Realm file path
        print(Realm.Configuration.defaultConfiguration.path!)
        
        // Set default settings
        let defaults = NSUserDefaults.standardUserDefaults()
        
        UserSettings.TextSize = defaults.doubleForKey(SettingsConstants.TextSize.key)
        if UserSettings.TextSize == 0.0 {
            UserSettings.TextSize = SettingsConstants.TextSize.Medium.value
        }

        UserSettings.EnterReaderModeFirst = defaults.boolForKey(SettingsConstants.EnterReaderModeFirst.key)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

