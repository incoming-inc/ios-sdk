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
    // ISDK initialization
    [ISDKAppDelegateHelper application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:launchOptions];
    
    // Register for remote notifications. The Incoming PVN uses silent remote notifications for content updates. 
    // You must call this method at some stage for the push video service to operate correctly. 
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

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler
{
    if ([ISDKAppDelegateHelper canHandleBackgroundURLSession:identifier]) {
        [ISDKAppDelegateHelper application:application handleEventsForBackgroundURLSession:identifier completionHandler:completionHandler];
    } else {
        // handle your app background download session here
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [ISDKAppDelegateHelper application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [ISDKAppDelegateHelper application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ([ISDKAppDelegateHelper application:application didReceiveRemoteNotification:userInfo] == NO)
    {
        // process your remote notification here
    }
}




@end
