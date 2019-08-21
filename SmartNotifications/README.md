Sourse Smart Notifications SDK template for iOS
===============================================


## Overview

Sourse smart notifications are essentially silent remote notifications, where for each notification received, the Sourse SDK creates 
a local user notifications which shown to the user at the optimal time to maximise the probabilty of the user opening it. 


## Sending smart notifications

Sourse's smart notifications are essentially silent notifications, sent using your existing push notification 
platform. Here is an example using the Google Firebase admin SDK for Javascript:

```
async function sendSourseSmartNotification(firebase, topic, title, body, actionURL, tag, expiry, isSmart) {
  var payload = {
    topic: topic,
    data: {
      'handler': 'com.sourse.notification',
      'title':  title,
      'message': body,
      'actionURL': actionURL,
      'isSmartNotification': isSmart
    }
  }
  return firebase.messaging().send(payload);
}
```

*Important*: If the `isSmartNotification` field is set to `0`, the Sourse SDK smart scheduling feature is bypassed, 
and the notification is immediately shown to the end-user (C.f. below for a full documentation of the notification payload).

If your use case includes some notifications to some topics to be shown immediately, and not delayed by the Sourse SDK, we recommend
using this feature. This way the Sourse analytics will include those notifications. 

## Receiving smart notifications

### Sourse SDK dependency

The sourse SDK version 2.6.2 or later is required. The recommended way of integrating the Sourse SDK is through cocoapod:

```
pod 'IncomingSDK/IncomingPVN', '~> 2.6.2'
```

### Sourse SDK integration

The sourse SDK requires a small number of UIApplicationDelegate methods to be forwarded, for the 
analytics and notification feature to function. C.f. [the sample app delegate](./client/SmartNotificationsDemo/SmarNotificationsDemo/AppDelegate.swift)
for a minimalist integration example. 

### Compatibility with other notifications

The sourse SDK contain a method to detect wether a push notification is a sourse smart notification
or not:

```
func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // ISDK method forward
        if ISDKAppDelegateHelper.application(application, didReceiveRemoteNotification: userInfo) == false
        {
            // this notification is not a Sourse smart notification,
            // process your app's remote notification here
            
        }
    }
```

Again, c.f. [AppDelegate.swift](./client/SmartNotificationsDemo/SmarNotificationsDemo/AppDelegate.swift)



## A/B testing

To A/B test the feature, the SDK includes a method to disable the Sourse smart scheduling (but retain the Sourse notifications analytics), which is equivalent
to sending the notification with the `isSmartNotification` flag to `0`. 

```
ISDKSmartNotifications.smartNotifications().isSmartNotificationDelayEnabled = enabled
```

For example if using Firebase, create a `is_smart_notification_enabled` remote config value, and 
configure the sourse's SDK `isSmartNotificationsEnabled` using a Firebase remote config value. 

c.f. [AppDelegate.swift](./client/SmartNotificationsDemo/SmartNotificationsDemo/AppDelegate.swift) for full example. 


## Smart notification payload specification


```
{
    // must be present in the payload
    'handler': 'com.sourse.notification',

    // the notification title text, visible to the end user
    'title':  'some title',

    // the notification body text, visible to the end user
    'message': 'some body', 

    // optional - the launch action URL to deep-link into the app content
    'actionURL': 'myapp://show/123323/episode/372',

    // optional - a tag to identify this notification, will be present in the analytics
    'tag': 'daily-show-123323',

    // optional - if present and 0, the notification will be shown immediately (Default or if omitted - is '1`).
    'isSmartNotification': '0',

    // optional - date after which we should not show this notification to the user
	// the format of this date is ISO-8601 and the format is: YYYY-MM-DDTHH:mm:ss.sssZ
	// always expressed in UTC (as indicated by the Z)
    'expiryDate': '2012-04-23T18:25:43.234Z',
    
    // optional - date before which we should not show this notification to the user
	// the format of this date is ISO-8601 and the format is: YYYY-MM-DDTHH:mm:ss.sssZ
	// always expressed in UTC (as indicated by the Z)
    'embargoDate': '2012-04-23T18:25:43Z'
}
```

*Important: all keys must be strings as per Firebase cloud messaging requirements*

## Incremental deployment considerations

Remember that Sourse smart notifications are essentially silent push notifications, where for each notification received, the Sourse SDK creates a local user notifications which is shown to the user at the optimal time to maximise the probabilty of the user opening it. 

Native application updates are incremental in nature, with some users not updating at all. One problem therefore is how to programmatically send smart (and silent) notifications to apps instances which have integrated the Sourse SDK while also sending standard, non-silent notifications to app instances which have not integrated the Sourse SDK. This is needed because the standard, non-silent notifications cannot be touched by the Sourse SDK - they are shown by the OS upon reception.  

We propose a solution to this problem when using Firebase cloud messaging (FCM) as a notification provider. 

Unfortunately, at the time of writing, Firebase Cloud Messaging does not support targeting specific app versions when sending cloud messages using the Firebase admin SDK / API (which is supported when sending in the console). One solution is to use the `conditions` feature of FCM, as follows: 

### Client

For any clients integrating the Sourse SDK

- In addition to any existing topic the user is subscribed to, additionally subscribe to a new topic called e.g.`sourse_sdk_integrated`.

C.f. [the example code](client/SmartNotificationsDemo/SmartNotificationsDemo/AppDelegate.swift) for code demonstrating this

### Backend

We use the Firebase Cloud Messaging 'conditions' feature to send ISDK smart notifications to clients who subscribe to the additional topic `sourse_sdk_integrated`, and to *only send the standard notifications to clients who don't*. This means the standard user-visible notifications are not sent to clients which have the sourse SDK integrated. 

This is possible thanks to the (conditional logic feature of FCM)[https://firebase.google.com/docs/cloud-messaging/send-message].

For each notification to be sent e.g. to the `23-show-23443-newepisode` topic, the backend now sends two notifications 
- one silent notification with the condition `'23-show-23443-newepisode' in topics && 'sourse_sdk_integrated' in topics`
- one normal (non silent) notification with the condition `'23-show-23443-newepisode' in topics && !('sourse_sdk_integrated' in topics)`


Example:

```
async function sendSourseSmartNotification(firebase, topic, title, body, actionURL, tag, expiry, isSmart) {
  var payload = {
    condition: `'${topic}' in topics && 'sourse_sdk_integrated' in topics`,
    data: {
      'handler': 'com.sourse.notification',
      'title':  title,
      'message': body,
      'actionURL': actionURL
    }
  }
  return firebase.messaging().send(payload);
}


async function sendStandardNotification(firebase, topic, title, body) {
  var payload = {
    condition: `'${topic}' in topics && !('sourse_sdk_integrated' in topics)`,
    notification: {
      title: title,
      body: body
    }
  }
  return firebase.messaging().send(payload));
}


async function sendNotification(firebase, topic, title, body, actionURL, tag, expiry, isSmart) {

  const p1 = sendSourseSmartNotification(firebase, topic, title, body, actionURL, tag, expiry, isSmart);
  const p2 = sendStandardNotification(firebase, topic, title, body);

  return Promise.all([p1, p2]);
}


```

c.f. [the example](server/sendNotifications.js) backend code demonstrating this. 




Simple template application that demonstrates how to integrate Sourse Smart Notifications in an iOS application, including A/B testing using firebase. 

Running this project requires:
- the project key supplied by Sourse
- a Firebase project configured for Firebase cloud messaging

