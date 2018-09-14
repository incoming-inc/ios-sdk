---
title: SDK configuration
layout: default 
---

### Create or edit the Incoming SDK Configuration File ###


Download the [incoming-ios-sdk.plist](./incoming-ios-sdk.plist) and add it to your project, in your main app's target. Make sure to check "copy files if needed", it needs to be be added to the app bundle. 

This incoming-ios-sdk.plist file is the main SDK configuration file, it must contain at minimum the following keys

 * `api_endpoint`: the Incoming API endpoint to connect to, e.g. api-sandbox.incoming.tv
 * `project_key`: your Incoming PVN project key

Enter the values supplied by your Incoming representative. The SDK is now operational.


Once done, you may want to proceed to the [Apple Push Notification configuration](./apns.html) - if relevant, or the [Testing / logging facility](./testing-logging.html)