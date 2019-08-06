Sourse Smart Notifications SDK template for iOS
===============================================

Simple template application that demonstrates how to integrate Sourse Smart Notifications in an iOS application, including A/B testing using firebase. 

This project requires
- the configuration file and SDK supplied by Sourse
- a Firebase project configured for Firebase cloud messaging


## Smart notification format

```
{
      'handler': 'com.sourse.notification',             // must be present in the payload
      'title':  title,                                  // the notification title text, visible to the end user
      'message': body,                                  // the notification body text, visible to the end user
      'actionURL': 'myapp://show/123323/episode/372',   // optional - the launch action URL to deep-link into the app content
      'tag': 'daily-show-123323',                       // optional - a tag to identify this notification, will be present in the analytics
      'isSmartNotification': 0,                         // optional - if present and 1, the notification will be shown immediately (Default is 0).
      'expiryDate': '2012-04-23T18:25:43Z',             // optional - date after which we should not show this notification to the user
      'embargoDate': '2012-04-23T18:25:43Z'             // optional - date before which we should not show this notification to the user
}
```