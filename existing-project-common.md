### Configure Background Modes ###

Using XCode, configure the application background modes:

 * click on your app target, then select `Capabilities`.
 * Turn on `Background Modes`
 * In Background Modes, enable `Background fetch` and `Remote Notifications`

![Background mode configuration ](./images/setup_target_capabilities.png)


### Add code to your app delegate ###

The host application delegate must to forward several calls from the operating system to the SDK. 
These are all implemented in the template application and can be conveniently copied from there. 

Take a look into the sample application’s delegate code:

 * Swift [https://github.com/incoming-inc/ios-sdk/blob/master/Swift/PVNSampleSwift/AppDelegate.swift](https://github.com/incoming-inc/ios-template-app/blob/master/Swift/PVNSampleSwift/AppDelegate.swift)
 * Objective-C [https://github.com/incoming-inc/ios-sdk/blob/master/Objective-C/PVNTemplate/PVTAppDelegate.m](https://github.com/incoming-inc/ios-template-app/blob/master/Objective-C/PVNTemplate/PVTAppDelegate.m)


The minimum code to add to your application delegate is as follows. 



	import UIKit

	@UIApplicationMain
	class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

	    var window: UIWindow?


	    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

	        // ISDK method forward
	        ISDKAppDelegateHelper.application(application, didFinishLaunchingWithOptions:launchOptions!)

	        // Register for remote notifications. The Incoming iOS uses silent remote notifications for content updates. 
	        // You must call this method at some stage. it will not prompt a notification permission dialog to the end-user, as only 
			// *silent* notifications are used. 
	        ISDKAppDelegateHelper.registerForRemoteNotifications()

	        // the two following calls are optional. They enable location and motion data collection
	        // which improves the timing prediction of Push Video Notifications.
	        // Calling these methods may result in the OS permission dialog being presented
	        // to the user.
	        ISDKAppDelegateHelper.registerForLocationUpdates()
	        ISDKAppDelegateHelper.registerForMotionActivity()


	        // <insert your app initialization code here>
	        return true
	    }

	    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
	        // ISDK method forward
	        ISDKAppDelegateHelper.application(application, performFetchWithCompletionHandler:completionHandler)
	    }
    
	    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
	        // ISDK method forward
	        ISDKAppDelegateHelper.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
	    }
    
	    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
	        // ISDK method forward
	        ISDKAppDelegateHelper.application(application, didFailToRegisterForRemoteNotificationsWithError:error)
	    }

	    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
	        // ISDK method forward
	        if ISDKAppDelegateHelper.application(application, didReceiveRemoteNotification: userInfo) == false
	        {
	            // process your app's remote notification here

	        }
	        completionHandler(.newData)
	    }
    
	    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
	        // ISDK method forward
	        if ISDKAppDelegateHelper.application(application, didReceiveRemoteNotification: userInfo) == false
	        {
	            // process your app's remote notification here
            
	        }
	    }
    
	    // Note: if you are targetting iOS 10 and up, this method is not needed
	    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
	        // ISDK method forward
	        if (ISDKAppDelegateHelper.application(application, didReceive: notification) == false)
	        {
	            // process your app local notification here
            
	        }
	    }
   


#### Objective-C ####

	#import "ISDKAppDelegateHelper.h"
	...


	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		[ISDKAppDelegateHelper application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:launchOptions];
		
		// Set the UNUserNotificationCenterDelegate - iOS > 10
		if (NSClassFromString(@"UNUserNotificationCenter")) {
	        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
	        center.delegate = self;
	    }

		// this registers for remote notifications on iOS > 8. It must be called
		// at some stage in your app initialization. Note that this method will never
		// result in a notification permission dialog being shown to the user. 
		[ISDKAppDelegateHelper registerForRemoteNotifications];

		// the two following calls are optional. They enable location and motion data collection
		// which improves the timing prediction of Push Video Notifications
		// calling these methods may also result in the OS permission dialog being presented
		// to the user.
		[ISDKAppDelegateHelper registerForMotionActivity];
		[ISDKAppDelegateHelper registerForLocationUpdates];

		return YES;
	}	

	- (void) application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
		[ISDKAppDelegateHelper application:application performFetchWithCompletionHandler:completionHandler];
	}

	- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
	{
		[ISDKAppDelegateHelper application:application handleEventsForBackgroundURLSession:identifier completionHandler:completionHandler];
	}

	- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
	{
		[ISDKAppDelegateHelper application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
	}

	- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
	{
		[ISDKAppDelegateHelper application:application didFailToRegisterForRemoteNotificationsWithError:error];
	}

	- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
	fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
	{
		[ISDKAppDelegateHelper application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
	}

	- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
	{
		[ISDKAppDelegateHelper application:application didReceiveRemoteNotification:userInfo];
	}


	

Once done, you may want to proceed to the [SDK settings configuration](./sdk-settings.html)
