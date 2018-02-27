---
title: Integration using Cocoapod
layout: default 
---

### Pre-requisite ###

Install cocoapod, by following the [installation guide](https://guides.cocoapods.org/using/getting-started.html#toc_3).

### Amend your podfile ###

Below is an example of cocoapod file. You need to replace the target names with the name of your app target. 

        platform :ios, '8.0' # or higher
        use_frameworks!

        target 'MyApp' do
          pod 'IncomingSDK/IncomingPVN'
        end


Once added, run `pod install`.


{% include_relative existing-project-common.md %}