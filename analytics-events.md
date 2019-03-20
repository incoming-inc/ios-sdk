---
title: Sourse iOS SDK - Analytics events
layout: default 
---

### Recording custom analytics events ###

The Sourse SDK supports recording custom analytics events.


#### Setting an external user ID

Setting an external user ID is useful to reconcile the Sourse analytics with another external analytics service, i.e. firebase. 
You can pass the external analytics service user ID to the Sourse SDK using the method

`[ISDKAppDelegateHelper setUserId:(nullable NSString *)userId]`

#### Recording custom events

To record custom, application-defined events in the Sourse analytics service, use the following method:
 
~~~~
 [ISDKAppdelegateHelper recordApplicationEvent:(nonnull NSDictionary *)parameters
					         completionHandler:(void (^_Nullable)(void))handler]
~~~~

The `parameters` dictionary contains the application event parameters. All keys in this dictionary must be NSString, 
all values in the dictionary must be NSString or NSNumber. 

The (optional) handler parameter is a block to be called when done - this is useful if called in the background. 

