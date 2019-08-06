//
//  PVTAppDelegate.m
//  PVNTemplate
//
//  Created by doug wright on 10/06/14.
//  Copyright (c) 2014 Incoming Pty Ltd. All rights reserved.
//

#import "PVTAppDelegate.h"
#import <IncomingPVN/IncomingPVN.h>

@implementation PVTAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Enable debug logging
    [ISDKAppDelegateHelper enableDebugLogging:YES];
    
    // ISDK initialization
    [ISDKAppDelegateHelper application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:launchOptions];
    
    // Optional - if remote notifications are configured for ISDK
    [ISDKAppDelegateHelper registerForRemoteNotifications];
    
    
    return YES;
}


- (void) application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [ISDKAppDelegateHelper application:application performFetchWithCompletionHandler:completionHandler];
    
    /**
    If your app uses background fetch, you may want to serialize the work using, e.g. 
    
    [ISDKAppDelegateHelper application:application performFetchWithCompletionHandler:^(UIBackgroundFetchResult isdkResult) {
        // perform your app background fetch - and return result in appBackgroundFetchResult
        UIBackgroundFetchResult appBackgroundFetchResult = UIBackgroundFetchResultNewData;
        
        if (appBackgroundFetchResult == UIBackgroundFetchResultFailed) {
            completionHandler(UIBackgroundFetchResultFailed);
            return;
        }
        
        if (isdkResult == UIBackgroundFetchResultNewData || appBackgroundFetchResult == UIBackgroundFetchResultNewData) {
            completionHandler(UIBackgroundFetchResultNewData);
            return;
        }
        
        completionHandler(appBackgroundFetchResult);
    }];
    */
}


// Optional - if remote notifications are configured for ISDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [ISDKAppDelegateHelper application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// Optional - if remote notifications are configured for ISDK
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [ISDKAppDelegateHelper application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

// Optional - if remote notifications are configured for ISDK
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if ([ISDKAppDelegateHelper application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler] == NO)
    {
        // process your remote notification here.
        
        
        // call completion handler
        if (completionHandler)
        {
            completionHandler(UIBackgroundFetchResultNewData);
        }
    }
}

// Optional - if remote notifications are configured for ISDK
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ([ISDKAppDelegateHelper application:application didReceiveRemoteNotification:userInfo] == NO)
    {
        // process your remote notification here
    }
}




@end
