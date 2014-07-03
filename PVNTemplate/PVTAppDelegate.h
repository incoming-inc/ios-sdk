//
//  PVTAppDelegate.h
//  PVNTemplate
//
//  Created by doug wright on 10/06/14.
//  Copyright (c) 2014 Incoming Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ISDKAppDelegateHelper.h"

@interface PVTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(strong,nonatomic) ISDKAppDelegateHelper *delegateHelper;

@end
