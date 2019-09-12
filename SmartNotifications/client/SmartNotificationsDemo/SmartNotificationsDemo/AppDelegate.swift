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
        
        // Firebase config
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // Notification center
        UNUserNotificationCenter.current().delegate = self;
        
        
        // Debug logging for ISDK
        ISDKAppDelegateHelper.setDebugLogging(true)
        
        // ISDK method forward
        ISDKAppDelegateHelper.application(application, didFinishLaunchingWithOptions:launchOptions)
        ISDKAppDelegateHelper.registerForRemoteNotifications()
        
        
         // request notification permission, somewhere in your app flow
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { _, error in
            if let e = error {
                NSLog("error - \(e.localizedDescription)")
            }
        }
        
        // Firebase remote config update
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
    
    // Your host-app deep linking
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NSLog("opening URL \(url .absoluteString)");
        return true;
    }
    
    // MARK: - Sourse smart notifications - Added methods
    
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
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if (ISDKAppDelegateHelper.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler) == false) {
            // this notification is not a Sourse smart notification
            // process your app's remote notification here
            
            
            // and only then call the OS completion handler
            completionHandler(.noData)
        }
    }
    
    // if the host app min target iOS version is < 10.0 and you want to display notifications while the app is running.
    // Otherwise this method may be ommitted
    func application(_ application: UIApplication,
                     didReceive notification: UILocalNotification) {
        // ISDK method forward
        if (ISDKAppDelegateHelper.application(application, didReceive: notification) == false) {
            // this notification is not a Sourse smart notification,
            // process your app's local notification here
        }
    }
    
    // if the host app min target iOS version is < 10.0
    // Otherwise this method may be ommitted
    func application(_ application: UIApplication,
                     handleActionWithIdentifier identifier: String?,
                     for notification: UILocalNotification,
                     completionHandler: @escaping () -> Void) {
        // ISDK method forward
        if (ISDKAppDelegateHelper.application(application,
                                              handleActionWithIdentifier: identifier,
                                              for: notification,
                                              completionHandler: completionHandler) == false) {
            // this notification is not a Sourse smart notification,
            // process your app's local notification here
            
            // and call the OS completion handler
            completionHandler()
        }
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // ISDK method forward
        ISDKAppDelegateHelper.application(application, performFetchWithCompletionHandler:completionHandler)
    }

}

// MARK: - UNUserNotificationCenterDelegate methods
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // ISDK method forward
        ISDKAppDelegateHelper.userNotificationCenter(center, didReceive: response) { (isISDK) in
            if !isISDK {
                // this notification is not a Sourse smart notification,
                // process your app's local notification here
            }
            // always call the completion handler
            completionHandler()
        }
    }
    
}

/// Firebase messaging delegate
extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
     
        // subscribe to this topic if the Sourse SDK is deployed
        Messaging.messaging().subscribe(toTopic: "sourse_sdk_integrated");

        // as an example here, subscribe to a show topic
        Messaging.messaging().subscribe(toTopic: "smartNotificationTest")
    }
    
}
