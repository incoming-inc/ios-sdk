---
title: Incoming iOS SDK - Logging
layout: default 
---

#### Logging facility

Enable debug logging on the Incoming SDK using the `[ISDKAppDelegateHelper setDebugLogging:BOOL]` method. When enabled, look out 
for initialization messages in the console, on app startup: 

~~~~
ISDK: Incoming SDK version 2.3-48-g930a029a
ISDK: Initialized ok
~~~~

Similarly, when recording a custom analytics event using `ISDKAppdelegateHelper recordApplicationEvent:...`, look out the following message:

~~~~
ISDK: Event recorded
~~~~
