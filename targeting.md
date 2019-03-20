---
title: Audience Segmentation
layout: default 
---

Audience segmentation support is available in version 1.8.X and above of the Push Video SDK.

Content targeting can be automatically configured as part of content metadata ingestion, or can be manually configured using the Push Video Control Panel.

Content can be targeted to audience segments based on the following attributes: 

* Country / Region Language
* Mobile Carrier
* Dormancy – the time since the user last engaged with the app, e.g. target a video to users who have been dormant for 3+ days.


The Push Video SDK manages these attributes automatically. You can configure any video in the Sourse control panel, to target specific values for these attributes. For example you may target a particular video to only appear for users in New-York City, or Washington and/or who are using Verizon. 

The host application can also provide custom targeting attributes, for example ‘team’ for a sports app, or ‘topic’ for a news app. The host application must then inform the Push Video SDK about the targeting attributes using the  [segmentation API](apidoc/html/Classes/ISDKDataAccessService.html#//api/name/setUserFilteringKeys:error:). 

The host application should call this method every time the content targeting preferences are changed by the user or by the host application. Note that keys and values are case-sensitive, and contains alphanumerical characters only. The Sourse control panel will automatically discover new key, values submitted by your app instances. These keys / values can then be used in the Sourse control panel, to target any video to specific groups of users. 

