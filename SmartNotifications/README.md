Sourse Smart Notifications SDK template for iOS
===============================================

Simple template application that demonstrates how to integrate Sourse Smart Notifications in an iOS application, including A/B testing using firebase. 

This project requires
- the configuration file and SDK supplied by Sourse
- a Firebase project configured for Firebase cloud messaging


## Smart notification payload

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
    'expiryDate': '2012-04-23T18:25:43Z',
    
    // optional - date before which we should not show this notification to the user
    'embargoDate': '2012-04-23T18:25:43Z'
}
```