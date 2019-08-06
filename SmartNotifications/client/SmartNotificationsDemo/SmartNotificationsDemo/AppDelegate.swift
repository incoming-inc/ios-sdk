//
//  AppDelegate.swift
//  SmartNotificationsDemo
//
//  Created by Sebastien Ardon on 12/7/19.
//  Copyright © 2019 Sourse. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import IncomingPVN

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        ISDKAppDelegateHelper.application(application, didFinishLaunchingWithOptions:launchOptions)
        ISDKAppDelegateHelper.registerForRemoteNotifications()
        
        setupFirebaseRemoteConfig() {
            let enabled = RemoteConfig.remoteConfig().configValue(forKey: kSmartNotificationRemoteConfigKey).boolValue
            self.configureSmartNotifications(enabled: enabled)
        }
        
        return true
    }

    /// Setup firebase remote config
    private func setupFirebaseRemoteConfig(completion: @escaping ()->()) {
        // setup and update firebase remote config
        
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        remoteConfig.fetch(withExpirationDuration: 24 * 3600) { (status, error) -> Void in
            if status == .success {
                remoteConfig.activate(completionHandler: { (error) in
                    DispatchQueue.main.async {
                        completion()
                    }
                })
            } else {
                NSLog("Could not update firebase remote config: " + (error?.localizedDescription ?? "unknown error"))
            }
        }
    }
    
    
    /// Sourse smart notifications - Added methods
    
    /// Enable / Disable smart notifications
    /// - parameter enabled: pass false to disable smart notifications
    private func configureSmartNotifications(enabled: Bool) {
        NSLog(enabled ? "Enabling" : "Disabling" + " Sourse smart notifications")
        ISDKSmartNotifications.smartNotifications().isSmartNotificationDelayEnabled = enabled
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // ISDK method forward
        ISDKAppDelegateHelper.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // ISDK method forward
        ISDKAppDelegateHelper.application(application, didFailToRegisterForRemoteNotificationsWithError:error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // ISDK method forward
        if ISDKAppDelegateHelper.application(application, didReceiveRemoteNotification: userInfo) == false
        {
            // this notification is not a Sourse smart notification,
            // process your app's remote notification here
            
        }
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // ISDK method forward
        ISDKAppDelegateHelper.application(application, performFetchWithCompletionHandler:completionHandler)
    }

}


/// Firebase messaging delegate
extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        Messaging.messaging().subscribe(toTopic: "/topics/smartNotificationTest")
    }
    
}
