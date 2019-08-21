Sourse Smart Notifications SDK template for iOS
===============================================

Simple template application that demonstrates how to integrate Sourse Smart Notifications in an iOS application, including A/B testing using firebase. 

This project requires
- the configuration file and SDK supplied by Sourse
- a Firebase project configured for Firebase cloud messaging


## Sourse SDK dependency

The sourse SDK version 2.6.2 or later is required

```

pod 'IncomingSDK/IncomingPVN', '~> 2.6.2'

```

## Sending smart notifications

Sourse's smart notifications are essentially silent notifications, sent using your existing push notification 
platform. C.f. the server folder for an example showing how to send such notifications using Firebase 
cloud messaging.

## Receiving smart notifications

The sourse SDK contain a method to detect wether a push notification is a sourse smart notification
or not. C.f. the client folder for the implementation details. 


## Smart notification payload specification

Note: all keys must be strings as per Firebase cloud messaging requirements. 

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

## Incremental deployment considerations

Remember that Sourse smart notifications are essentially FCM silent notifications, 
where for each notification received, the Sourse SDK creates a local user notifications which is shown at the optimal time, 
to maximise the probabilty of the user opening it. 

One problem is how to programmatically send smart (and silent) notifications to apps instances which have integrated the Sourse SDK, 
and standard standard, non-silent notifications to app instances which have not. 

Unfortunately, at the time of writing, Firebase Cloud Messaging does not support targeting specific app versions when sending cloud messages using the Firebase admin SDK / API (this is supported in the console).

To solve this, we propose to use the `conditions` feature of FCM, as follows: 

### On the client

- Configure the sourse's SDK `isSmartNotificationsEnabled` using a Firebase remote config value
- In addition to any existing topic the user is subscribed to, additionally subscribe to a new topic called e.g.`isdk_smart_notifications` (c.f. below)

C.f. [the example](client/SmartNotificationsDemo/SmartNotificationsDemo/AppDelegate.swift) for code demonstrating this

### On the backend

We use the Firebase Cloud Messaging 'conditions' feature to send ISDK smart notifications to clients who subscribe to the additional topic `isdk_smart_notifications`, and to *only send the standard notifications to clients who don't*. This is possible thanks to the condition logic feature of FCM, documented at https://firebase.google.com/docs/cloud-messaging/send-message:

For each notification to be sent to a topic, the backend will now send two notifications: 
- one silent notification addressed to condition `'${topic}' in topics && 'isdk_sdk_integrated' in topics`
- one normal (non silent) notification addressed with to the condition `'${topic}' in topics && !('isdk_sdk_integrated' in topics)`

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


c.f. [the example](server/sendNotifications.js) backend code demonstrating this