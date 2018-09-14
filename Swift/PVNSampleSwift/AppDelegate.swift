//
//  AppDelegate.swift
//  PVNSampleSwift
//
//  Created by Sebastien Ardon on 6/02/2015.
//  Copyright (c) 2015 Incoming Inc. All rights reserved.
//

import UIKit
import IncomingPVN

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // ISDK enable debug logging
        ISDKAppDelegateHelper.setDebugLogging(true);
        
        // ISDK method forward
        ISDKAppDelegateHelper.application(application, didFinishLaunchingWithOptions:launchOptions)
        
        // Optional - if remote notifications are configured for ISDK
        ISDKAppDelegateHelper.registerForRemoteNotifications()
        
        // the two following calls are optional. They enable location and motion data collection
        // which improves the timing prediction of Push Video Notifications.
        // Calling these methods may result in the OS permission dialog being presented
        // to the user.

        //        ISDKAppDelegateHelper.registerForLocationUpdates()
        //        ISDKAppDelegateHelper.registerForMotionActivity()
        
        // <insert your app initialization code here>
        return true
    }

    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // ISDK method forward
        ISDKAppDelegateHelper.application(application, performFetchWithCompletionHandler:completionHandler)
        
        // If your app uses background fetch, you may want to serialize the work, as shown in 
        // the objective-C example. 
        
    }
    
    
    // Optional - if remote notifications are configured for ISDK
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // ISDK method forward
        ISDKAppDelegateHelper.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        
    }
    
    // Optional - if remote notifications are configured for ISDK
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        // ISDK method forward
        ISDKAppDelegateHelper.application(application, didFailToRegisterForRemoteNotificationsWithError:error)
    }
    
    // Optional - if remote notifications are configured for ISDK
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        // ISDK method forward
        if ISDKAppDelegateHelper.application(application, didReceiveRemoteNotification: userInfo) == false {
            // process your app's remote notification here

        }
    }


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

