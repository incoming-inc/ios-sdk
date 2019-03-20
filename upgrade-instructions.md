---
title: Sourse iOS SDK - Upgrade instructions
layout: default 
---

Sourse SDK v2.5.1
-------------------
- No breaking API change introduced in this version. Just remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones, or use `pod update IncomingSDK`. 

Sourse SDK v2.5.0
-------------------
- No breaking API change introduced in this version. Just remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones, or use `pod update IncomingSDK`. 

Sourse SDK v2.4.0
-------------------
- No breaking API change introduced in this version. Just remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones, or use `pod update IncomingSDK`. 

Sourse SDK v2.3.5
-------------------
- No breaking API change introduced in this version. Just remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones, or use `pod update IncomingSDK`. 

Sourse SDK v2.3.4
-------------------
- No breaking API change introduced in this version. Just remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones, or use `pod update IncomingSDK`. 

Sourse SDK v2.3.3
-------------------
- No breaking API change introduced in this version. Just remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones, or use `pod update IncomingSDK` 

Sourse SDK v2.3.1
-------------------
- No breaking API change introduced in this version. Just remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones, or use `pod update IncomingSDK`. 

PVN SDK v2.3.0 - July 2017
--------------------------
- No breaking API change introduced in this version. Just remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones, or use `pod update IncomingSDK``. 

PVN SDK v2.1-26 - June 2017
---------------------------
- No breaking API change introduced in this version. Just remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones.


PVN SDK v2.0-233 - May 2017
-----------------------------
- No breaking API change introduced in this version. Just remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones.


PVN SDK v2.0-176 - March 2017
-----------------------------
- No breaking API change introduced in this version. Just remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones.


PVN SDK v2.0-160 - March 2017
-----------------------------
- No breaking API change introduced in this version. Just remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones.


PVN SDK v1.13 - Aug. 2016
-------------------------
- 1.13 brings support for UNUserNotifications and generally iOS 10 support
- To update, remove the old Incoming-PVN.{bundle,framework} and ISDKWidget.{bundle,framework} from your project, replacing with the new ones
- You must call the 
	- [ISDKAppDelegateHelper userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:completionHandler]
	- [ISDKAppDelegateHelper userNotificationCenter:willPresentNotification:withCompletionHandler]
methods from your UNUserNotificationCenterDelegate. C.f. example at [https://github.com/incoming-inc/ios-template-app](https://github.com/incoming-inc/ios-template-app)


v1.12-129 - May 2016
--------------------
- Remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones.
- Added [ISDKAppDelegateHelper registerForRemoteNotifications] method. This method must now be called at some point during the app initialisation for the PushVideo Service to function. 


v1.12 - Fev 2016
----------------
- No breaking API change introduced in this version. Just remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones.

v1.10 - January 2016
--------------------
- No breaking API change introduced in this version. Just remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones.


v1.9 - January 2016
-------------------
- No breaking API change introduced in this version. Just remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones.


v1.8 - September 2015
---------------------
- No breaking API change introduced in this version. Just remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones. If upgrading directly from v1.2, have a look at the 1.3 and 1.4 upgrade instructions below. If upgrading from 1.3 take a look at the 1.4 upgrade instructions below. 



v1.6-39 - 21st August 2015
--------------------------
- No breaking API change introduced in this version. Just remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones. If upgrading directly from v1.2, have a look at the 1.3 and 1.4 upgrade instructions below. If upgrading from 1.3 take a look at the 1.4 upgrade instructions below. 


v1.4-17 - 8th July 2015
------------------------

- No breaking API change introduced in this version. Just remove the old Incoming-PVN.{bundle,framework} from your project, and add the new ones. If upgrading directly from v1.2, have a look at the 1.3 upgrade instructions below. 
- The today widget is now distributed in binary form. It is packaged as a framework and bundle, making integration far easier. The widget / SDK API however hasn't changed, so you can either keep your existing widget code, or upgrade to the binary distribution and benefit from the new features (in-widget video experience mostly). Please contact your Sourse re-presentative to access widget source code, and/or for customisation options. 



v1.3-148 - 16th June 2015
-------------------------

- No breaking API change introduced in this version

- SDK is now bundled as a .framework and .bundle for convenience. To upgrade, discard the old `libincoming-ios-sdk.a`,  `incoming-ios-sdk-resources.bundle` and `include/ISDKDelegateHelper.h` from your project in XCode (make sure to keep your `incoming-ios-sdk.plist` config file which remains unchanged). Then import the content of the SDK distribution. You should have a .bundle and a .framework files added to your main application target. 

- The widget code has been refactored to more closely follow Apple's guidelines. Drag and drop the widget code onto your widget target, make sure to set the widget main storyboard as described in the [widget integration](./widget-integration.html) section.

